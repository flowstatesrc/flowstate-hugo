---
breadcrumb: Home
subtitle: Develop Faster
principal:
  title: Flow State is a framework for building backend APIs using SQL and JavaScript
  content: Query your PostgreSQL database directly from the frontend, write the validation, auth, and business logic alongside the frontend code which invokes it. 
    - __FREE for teams of up to 3 developers. 90-day no credit card free trial.__ 
    - Your code can run on the frontend, backend, or both - it's all JavaScript. 
    
    - API code is more accessible and readable to frontend devs, leading to fewer bugs.
    
    - Write SQL queries in the frontend returning JSON - save time and reduce boilerplate.
    
    - _Never get blocked waiting for the backend team_ to make changes. Eliminate bottlenecks.

    - Add Flow State incrementally to any PostgreSQL project, with any JavaScript framework.

    - Does your laundry. No, we made that up. But if you use it in a smart-washer let us know!
callout:
    title: Less meetings and organizational overhead
    content: "
        ![Reduce communication and meeting overhead](images/bad-meeting.jpg)
        Companies with separate frontend and backend roles have to cope with the special organizational
        hell which inspired us to create Flow State. The divided team structure has a high communication
        and context switching overhead. Flow State could realistically double the team velocity and reduce defects.
        No more tasks blocked for days waiting for the backend team to make changes. Unify your team and empower your developers."
blurbs:
  simple:
    title: Security with No Compromises 
    content: "The Flow State compiler separates out the backend code and queries using tree-shaking. Backend code and queries don't get sent to the browser. SQL template literals prevent SQL injection."
  dashboards:
    title: Native Performance
    content: "Flow State server is implemented with Rust and V8, and has been heavily optimized to take advantage of all CPU-cores efficiently. The server handles 10-40x the load of a typical Python or Ruby API."  
  custom:
    title: SQL is the Original GraphQL
    content: "Why not use SQL as the frontend query language over GraphQL? It involves no extra layer, is well known to developers, has full query capabilities, and doesn't suffer from the pesky [N+1 problem](https://shopify.engineering/solving-the-n-1-problem-for-graphql-through-batching) of GraphQL. For a private API, SQL is a superior choice."
  alerts:  
    title: Integrates with GitHub
    content: "Deploy automatically on commit to a configured production branch. Enable preview deployments for commits to feature branches. Make it really easy to deploy, test, and share your application. Roll back deployments just as easily."
---

## Show me the Code!

Define a query using the sql template tag in JavaScript.

```js
const query = sql`SELECT * FROM users WHERE group = ${group}`;
```

That looks like asking for a SQL injection attack, but it's not a string substitution.

```js
> console.log(query)
```
```json
{"query": "SELECT * FROM users WHERE group = $0", "params": "TODO"}
```

Executing the query is as simple as

```js
const result = await fs.executeQuery(query);
```

Where result is an iterator over JavaScript objects

```js
> for (const user of result) {
> 	console.log(user);
> }
```
```json
{"id": 1, "username": "bob", ...}
```
```json
{"id": 2, "username":  "alice", ...}
````

Result also has some support for paging, getting total and affected row count, etc. 
You can write insert or update queries the same way, but you're also going to want to
place some additional restrictions on what data can be saved, beyond the restrictions of the schema.

```js
function isValidEmail(params, errors) {
  const email = param["email"];
  // At minimum an email should be x@y.ab
  if (typeof email !== "string" || email.length < 6 ||
      email.indexOf('@', 1) < 0 || email.indexOf('.', 3) < 0) {
  	errors.add("email", "please enter a valid email address");
  }
}

let email = "not an email"; 
const changeEmail = sql`UPDATE users SET email = ${email}
                        WHERE id = %{SESSION.user_id}`;

// throws a ValidationError
const result = await fs.executeQuery(changeEmail, isValidEmail);
```

The isValidEmail function will run in the browser before sending the query, it will also run on
the server before executing the query. Note the use of a `%{SESSION}` variable here which
is replaced on the server-side with the value from the current user's session. This ensures
the user may only modify their own email address.

### I see some problems with this idea

By now you may be thinking of a half-dozen reasons why this would never work. From Hacker News:

1. It's unsafe to allow arbitrary queries against the database, even if you can lock it
   all down with a dedicated user and row-level permissions, people could still DoS your
   database with pathological queries.
   
  > We allow arbitrary queries only in development mode. In production all queries are compiled
  away to hashes, only those queries specifically coded by your developers can run - the same
  as in any normal backend.

2. Responsibility for query performance might now fall on your frontend engineer. Are
   the appropriate indices in place?

  > Don't underestimate your frontend engineers, they can learn and become just as proficient at SQL.
  However, hopefully your backend engineers are also pitching in with helping write and optimize the
  queries and sharing their experience.

3. The entities that make the most sense for storing your data into a database are not necessarily
   the same entities that make the most sense for using in a UI.

  > Query whatever data you want from multiple tables into a single entity. Remap those entities
  however you like, either on the frontend, or on the backend using views.

4. What about backwards compatibility, deleting a column/table may break the frontend.

  > Normally deleting a column or table will break the backend, and may break the frontend. This
  is really just one less layer to keep up to date. Strongly consider using views to enable
  backwards compatibility. However, it's possible to implement breaking changes during a
  deploy. Once deployed, older clients accessing the server will receive a version error and
  force a refresh to update to the latest code - a feature in itself that is extremely useful.

### What about transactions or backend logic?

One problem is it's a bad idea to hold transactions open in an interactive session split
across a high latency link, like between the browser and the server. Transactions hold
locks and block other transactions, so you want them to run as quickly as possible. The
ideal is to run all transactions inside stored procedures in the database. You can do that
with Flow State, but it's not always practical. The next best thing is to run
your transaction close to the database. You can do that with backend functions.

Writing and calling a backend function is really simple, and brings back good memories of
one of the things the Meteor framework did well:

```js
async function transferBalance(ctx, fromAccount, toAccount, amount) {
  const query = sql`SELECT balance FROM accounts WHERE id = ${fromAccount}`;
  const result = await ctx.executeQuery(query);
  
  const existingBalance = result.next().value;
  if (existingBalance == null || existingBalance < amount) {
    throw new Error("insufficient balance");
  }
  
  // Credit the destination account
  let account_id = toAccount;
  const update = sql`UPDATE accounts SET balance = balance + ${amount}
                     WHERE id = ${account_id}`;
  await ctx.executeQuery(update);
  
  // Debit the source account
  update.params["account_id"] = fromAccount;
  update.params["amount"] = -amount;
  await ctx.executeQuery(update);
  
  // commit is automatic if the function returns without throwing an exception
  // but you can make it explicit too
  await ctx.commit();  
}

let fromAccount = 1401234;
let toAccount = 1409832;
await transferBalance(fs.begin(), fromAccount, toAccount, 100);
```

Here `transferBalance` executes on the server. The Flow State compiler lifts it completely
out of the frontend and compiles it into the backend code bundle which is what you deploy.
The call site at `await transferBalance` is turned into fetch invocation marshaling the
arguments as JSON and unmarshalling the JSON result. You can tell you're looking at a
backend function by the ctx first argument, and a backend call by the `fs.begin()` that
you must pass as the first argument. It may seem slightly magical, but it's done this way
so that if you add type annotations (e.g. TypeScript) then the compiler will check the 
parameter and return types, and ensure you called it correctly by passing `fs.begin()`.

The compiler uses tree-shaking based on ES6 imports to lift functions out of the frontend.
Any code only referenced by backend functions will be completely removed. Shared functions will
be compiled into both frontend and backend. For this to work properly you must use ES6
imports between your frontend components. You should be doing this anyway though, and
most people are.

The end result of this is you can use share code almost freely between the frontend and backend.
This is still limited by differences between the frontend and backend environments - but
we're working at adding standard web APIs to the backend to fill in the gaps. Unlike node,
we don't add additional backend APIs, except for the special context object.

What's interesting about this is you can put your backend API function
in the same file as the component that calls it, or you can put them in adjacent files.
When a developers wants to know what happens in a particular edge case, the code for
the backend function is readily available and in the same language. In practice this
leads to less developers getting stuck waiting for answers from the backend team, and
less bugs when developers didn't go to the effort to check the backend code.

### What about third party APIs?

One of the main tasks of a backend is to interact with third-party APIs. You can
do this in Flow State by using the same standard fetch function you're used to in 
the browser. We'll also be adding various other browser functions you're used to
like WebCrypto in the near future.

```js
async function getAnswer(data) {
  const response = await fetch("https://example.com/answer", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    redirect: "error",
    body: JSON.stringify(data)
  });
  return response.json();
}

const answerData = await getAnswer({"answer": 42});
```

Client libraries that work in the browser can usually be used without modification
or polyfills. Client libraries that expect to work in a NodeJS environment
likely will not work well. You should use the REST APIs directly with fetch.
This is a weakness we intend to address down the road.

We also log fetch requests and responses, along with how long they take, which
really can speed up debugging issues with third-party integrations or identifying
performance bottlenecks. You can see at a glance when a third-party dependency goes
down and hold them accountable to their SLAs. These logs can be disabled in the configuration.