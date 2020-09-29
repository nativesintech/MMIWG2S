So it looks like Aurora can be pretty expensive if it is a db that is going to be constantly running. There are 8760 hours in a year * .08 per hour = $700. The db does shut down during periods of inactivity though so you won't be charged when people aren't using the app. Lambda is 20 cents per 1 million request plus you are charged by duration for every gig used $0.00001666667 (super straight forward pricing I know). There is no free tier for Aurora at this time.
There is Amazon RDS which you can also use Lambda with (same lambda pricing applies). A micro Amazon RDS for Postgres instance costs 0.018 per hour * 8760 = 157.68 a year. This one doesn't shut down when it is inactive though and you are charged from when it is launched to when it is stopped or deleted. That being said, the free tier for this allots for 750 hours of micro db usage with 20GB of SSD storage and 20GB of backup storage. If you think the data is going to stay below that, this might be the best option for you.
Dreamhost is a guaranteed 2.59 a month, but doesn't provide a db, it looks like it is just for hosting a website...specifically a Wordpress site. Technically it says you can host other websites, but I am concerned about how difficult it would be to do so since It does not appear to be their niche (I can dig further into this)

Looks like CloudSQL is Google's RDS equivalent. Using Postgres, they price it at 0.0105 per hour which seems like slightly less, but actually comes out to $91.98 per year.
Cloud Spanner seems to be their Aurora equivalent. However, you pay per node, plus the amount of data, plus the network bandwidth used. I’m not going to bother doing the math, just one node is almost a dollar per hour. 

Back to dreamhost…According to that page that lists their technologies, you would be looking at a NoSQL (document) db since it only lists MongoDB. However, given that these are servers you can use one to host a MySQL or I would assume Postgres DB. It also says that the level that is “ideal for websites” costs $12 a month so $144 per year, that’s for 2GB RAM. However, the smallest version they have is 512 GB RAM and would cost $54 a year. That being said., you would need to host a db as well and you would need to host a website on here. The one that says it is ideal for databases is a Max of $48 per month….Going with them also means a lot of setup….it isn’t just set some preferences and push a few buttons. This seems like a build and manage your database the old fashioned way.

For RDS It is about .001-.002 cheaper to use MySQL, difference of $8.76-17.52 per year

So, Firebase seems like it is more for syncing data between devices. That being said, it looks like it is only for mobile. Realtime database are free for up to 100 simultaneous connection, 1GB of storage and 10GB downloaded per month. If you do Firestore, it is priced based on reads, writes, deletes, and stored data. (Las Vegas is cheapest):

So Cloud Firestore is cross platform (can be used for things other than apps), but is also NoSQL

Looks like Cloud Firestore is the way to go and we should have the key of each document be the state to limit the number of reads. We do have to be careful though becuase each document is limited to 1MB of data. Since the images are going to be much larger than this, we are going to probably store them in Cloud Storage and then just put the url to them in Firestore.

Some more things about Firestore, in case you somehow end up with more than 1MB of data, apparently documents can get stored in what are called collections, so you probably will want to set up the database to have a collection per state, though initially trying to keep it to one document per state will be ideal. For scalability though, preparing for a collection of docs per state is ideal.

Some limitations you should know. You can't do wildcard searches, OR queries, != queries, or try to search for fields that don't exist (I don't think these will be an issue just food for thought, so to speak)

As for Cloud Storage there are 4 types; standard, nearline, coldline, and archive. We will be using standard because the other 3 are for infrequent retrieval, which will not be the case with our pictures. This will cost $.02 per GB per month.
