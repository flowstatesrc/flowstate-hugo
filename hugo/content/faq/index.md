---
type: faq
breadcrumb: FAQ
subtitle: Frequently Asked Questions
columns:
  -
    - general
    - security  
    - billing
  -    
    - how do I?
    - performance & scaling  
    - logging & metrics
    - compatibility
  
faq:
  general:
    - question: Is Flow State open-source?
      answer: "The compiler and client libraries are Apache 2 licensed.
        The server is not open-source. OSI open-source licenses are not suitable because they
        don't protect us from the big cloud companies who would just host Flow State as a 
        service and strangle us to death with our own product. We want our users to be able
        to dig into the source code if the documentation is lacking, or patch/modify the product
        to better suit their needs. So we will definitely release the source code under some kind
        of source visible license with a right to repair in the near future."
    - question: What happens if Flow State goes under or gets acquired?
      answer: We're not a venture funded company, we're a sustainably run private company. We're not going anywhere.
        However, as guarantee of business continuity we're making you the following legally binding promise in the EULA.
        If the company permanently halts development on the product for any reason then
        all the latest source code will be made available on GitHub under the Apache 2 license.        
        If a newer EULA weakens this guarantee, then the newer terms are void.
        Therefore, this promise stands even if the company is acquired and shutdown, goes bankrupt, etc.
    - question: What do I do with my backend engineers?
      answer: "Don't fire them, retrain them. Toyota famously put people to work painting their factories rather than let them go. #LearnToPaint.

      
      Don't mind my sense of humor, the reality is nobody yet has a magic wand to make backend code go away, only some of the boilerplate does. You want all of your engineers to be more comfortable with the full stack with Flow State so they can contribute where needed and understand the whole picture. You'll still want to assign your best backend people to the trickier queries and backend logic, and the best frontend people to the harder UI work. It's important to have them on the same team, working out of the same repo, deploying as one - this will really cut down on the amount of time wasted in communication and context switching compared to a siloed organization." 
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
    - question: What if we have fewer/more developers now
      answer: You can change the number of developers at any time from the admin UI, and your bill will be adjusted on a pro-rated basis.  
  logging & metrics:
    - question: What request data is logged?
      answer: "By default Flow State logs requests, responses, queries and subrequests (fetch) to _your_ S3-compatible cloud object storage. You can control what gets logged trough the various configuration settings. See the docs on configuration for more details. We also track some basic details about each request in your database, this can also be disabled or routed to a different database. These logs are your data, in your systems, you own and control it fully - this is never sent to our systems or used by us."
    - question: What data do you send to your servers?
      answer: "By default we track some anonymous usage statistics to help guide us in improving Flow State. You can disable this in the configuration. We also anonymously track unique monthly committers, this is for licensing reasons, and it can only be disabled on the enterprise plan."
  how do I?:
    - question: If I change the schema won't that break the client?
      answer: "Schema changes can be backward compatible or not. Even when they're not backwards compatible, you can define a view that makes it backward compatible. However, if you do wish to make a breaking change you declare that in the breaking migration or the config file and any older incompatible clients will be forced to update (by refreshing the browser.) This gives you full flexibility to manage the distributed system consisting of the frontend and backend components."
    - question: Won't this couple the frontend to the db schema?
      answer: "Most REST/GraphQL APIs track the schema pretty closely. If you change the schema later, you need to update the query and possibly also the code that uses it if the attributes change. That's exactly what you'd do with a conventional backend, except here it's the frontend that needs to be updated. You also have the option of keeping the API unchanged by adding a backward compatible view to your database - again nothing new here. However, if you expose your API to third parties, then you should use the RPC-style call interface which translates to a conventional REST API. For a third-party API you must have much stronger backward compatibility, so having that intermediate layer is beneficial."
---