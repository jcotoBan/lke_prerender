# Linode Prerender Use Case

The idea of this setup is to provide a scalable and reliable way to prerender javascript content in case of bot asks for the content.

If curious about prerendering and SEO, you can check this post: https://www.rankmovers.com/understanding-pre-rendering-in-seo/

## Preparing the setup.

To recreate this setup, you will require:

--> A kubernetes cluster, with right access configured to the api (in this case, a LKE cluster will be used)  
--> kubectl installed  
--> helm installed  
--> Certificates for the prerender endpoint. You can bring your own, or generate it with lets encrypt as will be done for this case.



