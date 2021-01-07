---
type: faq
breadcrumb: FAQ
subtitle: Frequently Asked Questions
sections:
  - general
  - performance & scaling
  - billing
  - logging & metrics
  - compatibility
  - how do i?
faq:
  general:
    - question: Is API Mate open-source?
      answer: "Yes our Cloudflare Workers app is open-source and daul-licensed under the AGPL v3 and API Mate license. Users on all paid plans are subject to the API Mate license only, not the AGPL. The source code is on github at: https://github.com/eloff/apimate-workers"
  compatibility:
    - question: Does API Mate work with Apollo or Relay?
      answer: Yes, these are fully supported. In fact API Mate is built on top of Apollo Server.
  performance & scaling:
    - question: How does caching work?
      answer: "You can enable simple edge caching for a duration in your schema using the [cacheControl directive](https://www.apollographql.com/docs/apollo-server/performance/caching/). It's possible to cache different fields of the same response for different lengths of time."
    - question: How well does API Mate scale?
      answer: "Because API Mate is built on top of Cloudflare Workers, it scales dynamically across 150+ edge datacenters and can handle massive traffic spikes or regional outages without breaking a sweat. Anycast TCP/IP automatically routes around failures."
    - question: Do you offer an SLA?
      answer: "Not yet, but contact us about it. Everything degrades gracefully when there's a failure or outage, so the only outages occur when your origin server is down, or all of Cloudflare goes down, which is very rare."
  how do i?:
    - question: How do roles work?
      answer: Roles can be stored in your system or ours and associated with a user or API key.
        Roles can be hierarchial, and each role can be used to grant row, column, and sort permissions, etc. If a user has more than one role involved in a security rule, they get access if any of the rules pass (rules are ORed together.) There’s also the special public role which represents permissions granted to all users, including unauthenticated users. You can create, manage, and assign roles through our GraphQL API.
    - question: What about ABAC (attribute-based access control)?
      answer: "The security rules system is a superset of both an RBAC and ABAC system. Access can be controlled by roles, by attributes on the user, attributes on the data itself. You can theoretically use any access control paradigm, or mix and match however you please."
    - question: What about capability based security?
      answer: "Capability-based security is another security paradigm where possession of a capability both designates the resources and grants some kind of permissions to access that resource. Security is achieved by controlling possession. It's particularily powerful when used with crypto-random UUIDs. As with ABAC, you have full freedom to structure your security as you like, so there is nothing preventing you from using a capability based access model."
    - question: What about very complex domain security logic?
      answer: "What if you want to grant read access to a few specific columns, write access to different columns,
        and only to manager roles, where their email address ends in acme.com, only on Mondays, and only to rows
        resources where the created_by field references users which are related to the manager as subordinates?
        You can implement that with API Mate. In addition to the flexible and powerful column and row based
        security, you can write and call custom JavaScript functions to your heart’s content. You can implement the most complex of access rules, while keeping all of the logic together in one place, separate from the rest of your code, and easy to audit for correctness."
  billing:
    - question: Do you have a free trial or a startup version? 
      answer: We have a free tier with no time limits, we bill based on the volume of queries. Some premium features aren't included in all tiers.
  logging & metrics:
    - question: Can I exclude data from the logs?
      answer: "You can filter out PII or other sensitive data from the logs by operation or by field."
    - question: Can I delete logs after a time period?
      answer: "Paid plans have different levels of maximum log retention. You can delete logs after a period of time by configuring custom retention globally or per operation."
---