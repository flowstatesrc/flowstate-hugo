---
type: faq
breadcrumb: FAQ
subtitle: Frequently Asked Questions
sections:
  - general
  - security  
  - billing
  - how do i?
  - performance & scaling  
  - logging & metrics
  - compatibility
  
faq:
  general:
    - question: Is Flow State open-source?
      answer: "The compiler and client libraries are Apache 2 licensed. The admin UI is source-visible. The server is not open-source. OSI open-source licenses are not suitable because they don't protect us from the big cloud companies who would just host Flow State as a service and pay us nothing for it. We will likely adopt a modified open-source license like the Timescale License."
    - question: Won't this couple the frontend to the db schema?
      answer: "Most REST/GraphQL APIs track the schema pretty closely. If you change the schema later, you need to update the query and possibly also the code that uses it if the attributes change. That's exactly what you'd do with a conventional backend, except here it's the frontend that needs to be updated. You also have the option of keeping the API unchanged by adding a backward compatible view to your database - again nothing new here. However, if you expose your API to third parties, then you should use the RPC-style call interface which translates to a conventional REST API. For a third-party API you must have much stronger backward compatibility, so having that intermediate layer is beneficial."
    - question: If I change the schema won't that break the client?
      answer: "Schema changes can be backward compatible or not. Even when they're not backwards compatible you can define a view that makes it backward compatible. However, if you do wish to make a breaking change you declare that in the breaking migration or the config file and any older incompatible clients will be forced to update (by refreshing the browser.) This gives you full flexibility to manage the distributed system consisting of the frontend and backend components."
    - question: What do I do with my backend engineers?
      answer: "Don't fire them, retrain them. Toyota famously put people to work painting their factories rather than let them go. #LearnToPaint.

      
      Please don't take umbrage with my sense of humor, the reality is nobody yet has a magic wand to make backend code go away, only some of the boilerplate does. You want all of your engineers to be more comfortable with the full stack with Flow State so they can contribute where needed and understand the whole picture. You'll still want to assign your best backend people to the trickier queries and backend logic, and the best frontend people to the harder UI work. It's important to have them on the same team, working out of the same repo, deploying as one - this will really cut down on the amount of time wasted in communication and context switching compared to a siloed organization." 
  security:    
    - question: How is it secure to run SQL from the browser?
      answer: "We only allow arbitrary queries in development. In production, the SQL query is compiled to the backend and referenced with a hash, it's not public and only queries you've explicitly coded can run - no different from any other REST or GraphQL API."
    - question: What about authorization?
      answer: "Backend code can save JSON attributes to a user session, and those values are available to the query. e.g. `SELECT * FROM users WHERE id = %{SESSION.user_id}` which would securely return only the user record for the logged in user."
    - question: What about SQL injection?
      answer: "The SQL template literals don't do string substitution, they replace the variables with a placeholder and pass the variable value separately so they're escaped by the database. This also let's us use prepared queries if it's worthwhile. As always, never construct queries with string concatenation."
    - question: What about validation?
      answer: "You can define validation functions that will run on both the frontend and backend, to give quick feedback to the user but also ensuring there is no way to bypass it. This is the best of all possible worlds for validating user input. You can also define backend only validation that does privileged things, like run queries or access session data."
  compatibility:
    - question: Does Flow State work with React or Vue?
      answer: Yes, Flow State client is a very light wrapper that should be compatible with any JavaScript UI framework. If you find the documentation lacking for your framework of choice, please submit a pull request!
    - question: What about mobile, does it work on iOS or Android?
      answer: If you use React native or similar, yes. Adding Java and Swift client libraries are high on our priorities. However, given you can't just update Android or iOS apps on demand querying directly from the app is less of a good idea. As with third-party focused APIs, you should probably stick to the RPC-style call interface which translates to a conventional REST API. Also you'd still need to write your backend functions in JavaScript, not Java or Swift. You don't want to rewrite those 3 times for each platform."
  performance & scaling:
    - question: How well does Flow State scale?
      answer: "Flow State scales close to linearly as you add CPU cores, and scales horizontally across multiple servers. It performs at native (comparable to C) speeds for queries. JavaScript runs in V8 slightly more efficiently than NodeJS or Deno because we've had the opportunity to learn from their mistakes. PostgreSQL will be the limiting factor for scaling, but we've got some things in the works that will help."
  billing:
    - question: Do you have a free trial or a startup version? 
      answer: We have a starter tier with no time limits for up to three developers. We also have a 90-day no credit card required free trial for all non-enterprise plans. Some premium features aren't included in all tiers.
    - question: We don't have new feature development anymore, do we still have to pay?
      answer: Pricing is by active developers per month, if there are less than 3 active developers in a given month, there is no charge for that month.
    - question: What if we have fewer/more developers some months
      answer: We bill automatically based on the number of active committers in your VCS repository.
    - question: What if we don't use a VCS?
      answer: Now you have two problems.
    - question: Do you offer an SLA?
      answer: "Yes, on the enterprise plan, please contact us to learn more."
    - question: Do you offer training?
      answer: "Yes, please contact us to learn more."
  logging & metrics:
    - question: What data is logged?
      answer: "By default we log requests, responses, queries and subrequests (fetch) to an S3-compatible cloud object storage. You can control what gets logged trough the various configuration settings. See the docs on configuration for more details. We also track some basic details about each request in your database, this can also be disabled or routed to a different database. These logs are your data, in your systems, you own and control it fully."
    - question: What data do you send to your servers?
      answer: "By default we track some anonymous usage statistics to help guide us in improving Flow State. You can disable this in the configuration. We also track unique monthly committers, this is for automatic license enforcement, and it can only be disabled on the enterprise plan."
---