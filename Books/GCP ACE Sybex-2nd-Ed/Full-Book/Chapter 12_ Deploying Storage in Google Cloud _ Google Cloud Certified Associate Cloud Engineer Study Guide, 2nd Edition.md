---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVES OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- **3.4 Deploying and implementing data solutions**
- **4.4 Managing storage and database solutions**

---

In this chapter, we will discuss how to create data storage systems in several Google Cloud products, including Cloud SQL, Cloud Datastore, BigQuery, Bigtable, Cloud Spanner, Cloud Pub/Sub, Cloud Dataproc, and Cloud Storage. You will learn how to create databases, buckets, and other basic data structures as well as how to perform key management tasks, such as backing up data and checking the status of jobs.

## Deploying and Managing Cloud SQL

Cloud SQL is a managed relational database service. In this section, you will learn how to do the following:

- Create a database instance.
- Connect to the instance.
- Create a database.
- Load data into the database.
- Query the database.
- Back up the database.

We will use a MySQL instance in this section, but the following procedures are similar for PostgreSQL and SQL Server.

### Creating and Connecting to a MySQL Instance

We described how to create and configure a MySQL instance in [Chapter 11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml), “Planning Storage in the Cloud,” but will review the steps here.

From the console, navigate to Cloud SQL and click Create Instance. Choose MySQL to open the page shown in [Figure 12.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0001).

After a few minutes, the instance is created; the MySQL list will look similar to [Figure 12.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0002).

![Snapshot of creating a MySQL instance](../images/c12f001.png)


[**FIGURE 12.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0001) Creating a MySQL instance

![Snapshot of a listing of MySQL instances](../images/c12f002.png)


[**FIGURE 12.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0002) A listing of MySQL instances

After the database is created, you can connect by starting Cloud Shell and using the `gcloud sql connect` command. This command takes the name of the instance to connect to and optionally a username and password. It is a good practice to not specify a password in the command line. Instead, you will be prompted for it, and it will not be displayed as you type. You may see a message about allowing the listing of your IP address; this is a security measure and will allow you to connect to the instance from Cloud Shell.

To connect to the instance called `ace-exam-mysql`, use the following command:

```
gcloud sql connect ace-exam-mysql –user=root
```

This opens a command-line prompt to the MySQL instance, as shown in [Figure 12.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0003).

![Snapshot of command-line prompt to work with MySQL after connecting using gcloud sql connect](../images/c12f003.png)


[**FIGURE 12.3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0003) Command-line prompt to work with MySQL after connecting using `gcloud sql connect`

### Creating a Database, Loading Data, and Querying Data

In the MySQL command-line environment, you use MySQL commands, not `gcloud` commands. MySQL uses standard SQL, so the command to create a database is `CREATE DATABASE`. You indicate the database to work with (there may be many in a single instance) by using the `USE` command. For example, to create a database and set it as the default database to work with, use this:

```
CREATE DATABASE ace:exam_book;
USE ace:exam_book
```

You can then create a table using `CREATE TABLE`. Data is inserted using the `INSERT` command. For example, the following commands create a table called `books` and inserts two rows:

```
CREATE TABLE books (title VARCHAR(255), num_chapters INT, entity_id INT NOT NULL AUTO_INCREMENT, PRIMARY KEY (entity_id));
INSERT INTO books (title,num_chapters) VALUES ('ACE Exam Study Guide', 18);
INSERT INTO books (title,num_chapters) VALUES ('Architecture Exam Study Guide', 18);
```

To query the table, you use the `SELECT` command. Here's an example:

```
SELECT * FROM books;
```

This command will list all the rows in the table, as shown in [Figure 12.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0004).

![Snapshot of listing the contents of a table in MySQL](../images/c12f004.png)


[**FIGURE 12.4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0004) Listing the contents of a table in MySQL

### Backing Up MySQL in Cloud SQL

Cloud SQL enables both on-demand and automatic backups.

To create an on-demand backup, click the name of the instance on the Instances page on the console. This will display the Instance Details page (see [Figure 12.5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0005)).

![Snapshot of partial listing of MySQL Instance Details page with vertical menu displayed on the left.](../images/c12f005.png)


[**FIGURE 12.5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0005) Partial listing of MySQL Instance Details page with vertical menu displayed on the left

Click the Backups menu option to display the Backups page (see [Figure 12.6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0006)).

![Snapshot of create Backup button](../images/c12f006.png)


[**FIGURE 12.6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0006) Create Backup button

Clicking Create Backup opens the window shown in [Figure 12.7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0007).

![Snapshot of assign a description to a backup and create it.](../images/c12f007.png)


[**FIGURE 12.7**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0007) Assign a description to a backup and create it.

Fill in the optional description and click Create. When the backup is complete, it will appear in the list of backups, as shown in [Figure 12.8](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0008).

![Snapshot of listing of backups available for this instance](../images/c12f008.png)


[**FIGURE 12.8**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0008) Listing of backups available for this instance

You can also create a backup using the `gcloud sql backups` command, which has this form:

```
gcloud sql backups create ––async ––instance [INSTANCE_NAME]
```

Here, *`[INSTANCE_NAME]`* is the name, such as `ace-exam-mysql`, and the `--async` parameter is optional.

To create an on-demand backup for the `ace-exam-mysql` instance, use the following command:

```
gcloud sql backups create ––async ––instance ace-exam-mysql
```

You can also have Cloud SQL automatically create backups.

From the console, navigate to the Cloud SQL Instance page, click the name of the instance, and then click Edit Instance. Open the Enabled Auto Backups section and fill in the details of when to create the backups (see [Figure 12.9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0009)). You must specify a time range for when automatic backups should occur. You can also enable binary logging, which is needed for more advanced features, such as point-in-time recovery.

To enable automatic backups from the command line, use the `gcloud` command:

```
gcloud sql instances patch [INSTANCE_NAME] –backup-start-time [HH:MM]
```

For this example instance, you could run automatic backups at 1:00 a.m. with the following command:

```
gcloud sql instances patch ace-exam-mysql –backup-start-time 01:00
```

![Snapshot of enabling automatic backups in Cloud Console](../images/c12f009.png)


[**FIGURE 12.9**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0009) Enabling automatic backups in Cloud Console

## Deploying and Managing Firestore

[Chapter 11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml) described how to initialize a Firestore document database. Now, you will see how to create entities and add properties to a document database. You'll also review backup and restore operations. Cloud Firestore is the latest generation of Cloud Datastore. Cloud Firestore has two modes: Native and Datastore mode.

Cloud Firestore's features include strong consistency, document data model, real-time updates, and mobile and web client libraries. Real-time updates and mobile and web client libraries are only available in native mode. Datastore mode can scale to millions of writes per second and is a good option for a document data store when you do not need the real-time or mobile features of Native mode. Datastore mode also supports the GQL query language, which is similar to SQL.

### Adding Data to a Firestore Database

You add data to a Firestore database in Native Mode using the Start Collection option in the Firestore section of the console. The Collections data structure is analogous to a schema in relational databases.

You create an entity by clicking Start Collection and filling in the form that appears. Here you will provide a collection ID and then add documents, which are key-value pairs with a data type on the value. (See [Figure 12.10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0010).)

After creating entities, you can view data in the console, as shown in [Figure 12.11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0011).

![Snapshot of adding data to a Firestore collection](../images/c12f010.png)


[**FIGURE 12.10**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0010) Adding data to a Firestore collection

![Snapshot of viewing data in Firestore, Native mode](../images/c12f011.png)


[**FIGURE 12.11**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0011) Viewing data in Firestore, Native mode

### Backing Up Firestore

To back up a Firestore database, you need to create a Cloud Storage bucket to hold a backup file and grant appropriate permissions to users performing backup.

You can create a bucket for backups using the `gsutil` command:

```
gsutil mb gs://[BUCKET_NAME]/
```

Here, *`[BUCKET_NAME]`* is the name, such as `ace:exam_backups`. In our example, we use `ace:exam_backups` and create that bucket using the following:

```
gsutil mb gs://ace:exam_backups/
```

Users creating backups need the `datastore.databases.export` permission. (Cloud Datastore was renamed to Cloud Firestore but at the time of writing, the IAM roles still refer to Datastore.) If you are importing data, you will need `datastore.databases.import`. The Cloud Datastore Import Export Admin role has both permissions; see [Chapter 17](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml), “Configuring Access and Security,” for details on assigning roles to users.

To create a backup by exporting from Firestore, you can use a command like this one:

```
gcloud fireststore export gs://ace:exam_backups
```

To import a backup file, use the `gcloud firestore import` command:

```
gcloud firestore import gs://ace:exam_backups
```

## Deploying and Managing BigQuery

BigQuery is a fully managed database service, so Google takes care of backups and other basic administrative tasks. As a Cloud Engineer, you still have some administrative tasks when working with BigQuery. Two of those tasks are estimating the cost of a query and checking on the status of a job.

### Estimating the Cost of Queries in BigQuery

In the console, choose BigQuery from the main navigation menu to display the BigQuery query interface, as partially shown in [Figure 12.12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0012).

Here you can enter a query in the Query Editor, such as a query about names and genders in the usa\_1910\_2013 table, as shown in [Figure 12.13](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0013).

Notice in the upper-right corner that BigQuery provides an estimate of how much data will be scanned. You can also use the command line to get this estimate by using the `bq` command with the `––dry-run` option:

```
bq ––location=[LOCATION] query ––use_legacy_sql=false ––dry_run [SQL_QUERY]
```

![Snapshot of the BigQuery console](../images/c12f012.png)


[**FIGURE 12.12**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0012) The BigQuery console

![Snapshot of example query with estimated amount of data scanned](../images/c12f013.png)


[**FIGURE 12.13**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0013) Example query with estimated amount of data scanned

Here, *`[Location]`* is the location in which you created the data set you are querying, and *`[SQL_QUERY]`* is the SQL query you are estimating.

You can use this number with the Pricing Calculator to estimate the cost. The Pricing Calculator is available at `https://cloud.google.com/products/calculator`. After selecting BigQuery, navigate to the On-Demand tab, enter the name of the table you are querying, set the amount of storage to **0**, and then enter the size of the query in the Queries line of the Queries Pricing section. Be sure to use the same size unit as displayed in the BigQuery console. When you click Add To Estimate, the Pricing Calculator will display the cost (see [Figure 12.14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0014)).

![Snapshot of using the Pricing Calculator to estimate the cost of a query](../images/c12f014.png)


[**FIGURE 12.14**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0014) Using the Pricing Calculator to estimate the cost of a query

### Viewing Jobs in BigQuery

Jobs in BigQuery are processes used to load, export, copy, and query data. Jobs are automatically created when you start any of these operations.

To view the status of jobs, navigate to the BigQuery console and click Personal History or Project History in the lower section of the edit window. Notice in [Figure 12.15](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0015) that the top job in the list has a check mark, indicating that the job completed successfully. This is an example of an expanded view of a job entry. Below that is a single-line summary of a job that failed. The failure is indicated by the exclamation point icon next to the job ID.

![Snapshot of a listing of job statuses in BigQuery](../images/c12f015.png)


[**FIGURE 12.15**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0015) A listing of job statuses in BigQuery

You could also view the status of a BigQuery job by using the `bq show` command. For example, the following command shows the status of the specified job:

```
bq --location=US show -j gcpace-project:US.bquijob_119adae7_167c373d5c3
```

## Deploying and Managing Cloud Spanner

Now, let's turn our attention to Cloud Spanner, the global relational database. In this section, you will create a database, define a schema, insert some data, and then query it.

First, you will create a Cloud Spanner instance. Navigate to the Cloud Spanner page in the console and click Create Instance. This will display the page shown in [Figure 12.16](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0016).

![Snapshot of creating a Cloud Spanner instance](../images/c12f016.png)


[**FIGURE 12.16**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0016) Creating a Cloud Spanner instance

Next, you need to create a database in the instance. Click Create Database at the top of the Instance Details page to show a page similar to [Figure 12.17](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0017).

![Snapshot of create a database within a Cloud Spanner instance.](../images/c12f017.png)


[**FIGURE 12.17**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0017) Create a database within a Cloud Spanner instance.

When creating a database, you will need to use the SQL data definition language (DDL) to define the structure of tables. SQL DDL is the set of SQL commands for creating tables, indexes, and other data structures (see [Table 12.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-tbl-0001)). [Figure 12.18](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0018) shows an example of using DDL templates provided by Google Cloud. In this case, the template for creating a table is displayed.

[**TABLE 12.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-tbl-0001) SQL data definition commands

| Command | Description |
| --- | --- |
| `CREATE TABLE` | Creates a table with columns and data types specified |
| `CREATE INDEX` | Creates an index on the specified column(s) |
| `ALTER TABLE` | Changes table structure |
| `DROP TABLE` | Removes the table from the database schema |
| `DROP INDEX` | Removes the index from the database schema |

In addition to creating a table, other templates are shown in [Figure 12.19](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0019).

![Snapshot of creating a table using a DDL template](../images/c12f018.png)


[**FIGURE 12.18**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0018) Creating a table using a DDL template

Once a table is created, you can view the structure and properties of the table, as shown in [Figure 12.20](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0020).

From the schema description of the table, you can navigate to Cloud Logging to see a history of changes to the table, as shown in [Figure 12.21](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0021).

![Snapshot of dDL templates available to help you create database objects in Spanner](../images/c12f019.png)


[**FIGURE 12.19**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0019) DDL templates available to help you create database objects in Spanner

Finally, you can review and add Spanner-related roles to principals from the Spanner console. From the Spanner instance list, select the check box for the instance. A panel will appear on the right similar to [Figure 12.22](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0022).

Cloud Spanner is a managed database service, so you will not have to patch, back up, or perform other basic data administration tasks. Your tasks, and those of data modelers and software engineers, will focus on design tables and queries.

![Snapshot of details of the table created in Spanner](../images/c12f020.png)


[**FIGURE 12.20**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0020) Details of the table created in Spanner

![Snapshot of log of changes to Spanner table](../images/c12f021.png)


[**FIGURE 12.21**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0021) Log of changes to Spanner table

![Snapshot of from the Show Info panel, you can view and manage Spanner-related roles.](../images/c12f022.png)


[**FIGURE 12.22**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0022) From the Show Info panel, you can view and manage Spanner-related roles.

## Deploying and Managing Cloud Pub/Sub

Two tasks are required to deploy a Pub/Sub message queue: creating a topic and creating a subscription. A topic is a structure where applications can send messages. Pub/Sub receives the messages and keeps them until they are read by an application. Applications read messages by using a subscription.

The first step for working with Pub/Sub is to navigate to the Pub/Sub page in Cloud Console. The first time you use Pub/Sub, the form will be similar to [Figure 12.23](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0023).

After you click Create A Topic, you will see a list of subscriptions, as shown in [Figure 12.24](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0024).

You will see a list of topics displayed in the Topics page after creating the first topic, as shown in [Figure 12.25](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0025).

To create a subscription to a topic, click the ellipsis icon at the end of the topic summary line in the listing. The menu that appears includes the Create Subscription option (see [Figure 12.26](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0026)). Click Create Subscription to create a subscription to that topic. This will display a page like that shown in [Figure 12.27](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0027).

![Snapshot of creating a Pub/Sub topic](../images/c12f023.png)


[**FIGURE 12.23**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0023) Creating a Pub/Sub topic

![Snapshot of list of subscriptions](../images/c12f024.png)


[**FIGURE 12.24**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0024) List of subscriptions

To create a subscription, specify a subscription name and delivery type. Subscriptions can be *pulled*, in which the application reads from a topic, or *pushed*, in which the subscription writes messages to an endpoint. If you want to use a push subscription, you will need to specify the URL of an endpoint to receive the message.

![Snapshot of subscription details](../images/c12f025.png)


[**FIGURE 12.25**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0025) Subscription details

![Snapshot of creating a subscription to a topic](../images/c12f026.png)


[**FIGURE 12.26**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0026) Creating a subscription to a topic

Once a message is read, the application reading the message acknowledges receiving the message. Pub/Sub will wait the period of time specified in the Acknowledgment Deadline parameter. The time to wait can range from 10 to 600 seconds.

You can also specify a retention period, which is the length of time to keep a message that cannot be delivered. After the retention period passes, messages are deleted from the topic.

When you complete creating a subscription, you will see a list of subscriptions like that shown in [Figure 12.28](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0028).

![Snapshot of the options for creating a subscription](../images/c12f027.png)


[**FIGURE 12.27**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0027) The options for creating a subscription

![Snapshot of a list of subscriptions](../images/c12f028.png)


[**FIGURE 12.28**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0028) A list of subscriptions

In addition to using the console, you can use `gcloud` commands to create topics and subscriptions. The commands to create topics and subscriptions are as follows:

```
gcloud pubsub topics create [TOPIC-NAME]
gcloud pubsub subscriptions create [SUBSCRIPTION-NAME] ––topic [TOPIC-NAME]
```

## Deploying and Managing Cloud Bigtable

As a Cloud Engineer, you may need to create a Bigtable cluster, or set of servers running Bigtable services, as well as create tables, add data, and query that data.

To create a Bigtable instance, navigate to the Bigtable console and click Create Instance. This will display the page shown in [Figure 12.29](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0029). (See [Chapter 11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml) for additional details on creating a Bigtable instance.)

Once an instance is created, you can view a summary of performance data in the Instance Details page, such as shown in [Figure 12.30](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0030).

Much of the work you will do with Bigtable is done at the command line.

To create a table, open a Cloud Shell browser and install the `cbt` command. Unlike relational databases, Bigtable is a NoSQL database and does not use the SQL command. Instead, the `cbt` command has subcommands to create tables, insert data, and query tables (see [Table 12.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-tbl-0002)).

[**TABLE 12.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-tbl-0002) `cbt` commands

| Command | Description |
| --- | --- |
| `createtable` | Creates a table |
| `createfamily` | Creates a column family |
| `read` | Reads and displays rows |
| `ls` | Lists tables and columns |

To configure `cbt` in Cloud Shell, enter these commands:

```
gcloud components update gcloud components install cbt
```

![Snapshot of creating a Bigtable instance](../images/c12f029.png)


[**FIGURE 12.29**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0029) Creating a Bigtable instance

Bigtable requires an environment variable called `instance` to be set by including it in a CBT configuration file called `.cbtrc`, which is kept in the home directory.

![Snapshot of instance details, including performance data](../images/c12f030.png)


[**FIGURE 12.30**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0030) Instance details, including performance data

For example, to set the instance to `ace-exam-bigtable`, enter this command at the command-line prompt:

```
echo instance = ace-exam-bigtable>> ~/.cbtrc
```

Now `cbt` commands will operate on that instance. To create a table, issue a command such as this:

```
cbt createtable ace-exam-bt-table
```

The `ls` command lists tables. Here's an example:

```
cbt ls
```

This will display a list of all tables. Tables contain columns, but Bigtable also has a concept of column families. To create a column family called `colfam1`, use the following command:

```
cbt createfamily ace-exam-bt-table colfam1
```

To set a value of the cell with the column `colfam1` in a row called `row1`, use the following command:

```
cbt set ace-exam-bt-table row1 colfam1:col1=ace-exam-value
```

To display the contents of a table, use a `read` command like this:

```
cbt read ace-exam-bt-table
```

## Deploying and Managing Cloud Dataproc

Cloud Dataproc is Google's managed Apache Spark and Apache Hadoop service. Both Spark and Hadoop are designed for “big data” applications. Spark supports analysis and machine learning, whereas Hadoop is well suited to batch, big data applications. As a Cloud Engineer, you should be familiar with creating a Dataproc cluster and submitting jobs to run in the cluster.

To create a cluster, navigate to the Dataproc part of Cloud Console and select Create Cluster; then choose the underlying infrastructure, which can be Compute Engine or Google Kubernetes Engine (see [Figure 12.31](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0031)). Google Kubernetes Engine is a good option if you have an existing GKE cluster and want to use it for a Cloud Dataproc managed Spark/Hadoop cluster. If you do not have a GKE cluster or do not want to run Cloud Dataproc clusters on your GKE clusters, then using Compute Engine is the better option.

![Snapshot of choose an infrastructure for your cluster, either Compute Engine or Google Kubernetes Engine.](../images/c12f031.png)


[**FIGURE 12.31**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0031) Choose an infrastructure for your cluster, either Compute Engine or Google Kubernetes Engine.

Create a Dataproc cluster by completing the Create Cluster options. You will need to specify the name of the cluster and a region and zone. You'll also need to specify the cluster mode, which can be Standard, Single Node, or High Availability. Single Node is useful for development. Standard has only one master node, so if it fails, the cluster becomes inaccessible. The High Availability mode uses three masters.

You will also need to specify machine configuration information for the master nodes and the worker nodes. You'll specify CPUs, memory, and disk information. The cluster mode determines the number of master nodes, but you can choose the number of worker nodes. If you choose to expand the list of advanced options, you can indicate you'd like to use preemptible VMs and specify the number of preemptible VMs you want to run (not shown in figures). [Figure 12.32](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0032) shows the options for creating a cluster on Compute Engine, and [Figure 12.33](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0033) shows the options for creating a cluster on Google Kubernetes Engine.

When the cluster is running, you can submit jobs using the Submit A Job page shown in [Figure 12.34](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0034).

![Snapshot of creating a Dataproc cluster on Compute Engine](../images/c12f032.png)


[**FIGURE 12.32**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0032) Creating a Dataproc cluster on Compute Engine

You will need to specify the cluster on which to run the job and the type of job, which can be Spark, PySpark, SparkR, Hive, Spark SQL, Pig, or Hadoop. The JAR files are the Java programs that will be executed, and the Main Class or JAR is the name of the function or method that should be invoked to start the job. If you choose PySpark, you will submit a Python program; if you submit SparkR, you will submit an R program. When running Hive or SparkSQL, you will submit query files. You can also pass in optional arguments.

![Snapshot of creating a Dataproc cluster on Google Kubernetes Engine](../images/c12f033.png)


[**FIGURE 12.33**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0033) Creating a Dataproc cluster on Google Kubernetes Engine

You can also create workflow templates in Cloud Dataproc (see [Figure 12.35](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0035)). Workflow templates allow you to define and execute workflows specified as a directed graph of jobs. With workflow templates, you can specify if you want to use a managed cluster, which would enable the workflow to create a cluster, run the jobs, and then shut down the cluster automatically. Alternatively, you can specify a cluster on which to run the jobs. Workflow templates are useful when you have to run complex jobs on Cloud Dataproc.

![Snapshot of submitting a job and choosing a job type](../images/c12f034.png)


[**FIGURE 12.34**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0034) Submitting a job and choosing a job type

In addition to allowing to create clusters and workflows, Cloud Dataproc supports a Serverless Spark option. You can run batch jobs by choosing the Batches option under the Serverless section of the Dataproc navigation pane, as shown in [Figure 12.36](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0036). With the Serverless option, you do not have to configure cluster resources or manage clusters.

In addition to using the console, you can create a cluster using the `gcloud dataproc clusters` command. Here's an example:

```
gcloud dataproc clusters create cluster-bc3d ––zone us-west2-a
```

![Snapshot of creating a workflow template](../images/c12f035.png)


[**FIGURE 12.35**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0035) Creating a workflow template

This command will create a default cluster in the us-west2-a zone. You can also specify additional parameters for machine types, disk configurations, and other cluster characteristics.

You use the `gcloud dataproc jobs` command to submit jobs from the command line. Here's an example:

```
gcloud dataproc jobs submit spark ––cluster cluster-bc3d \ ––jar ace:exam_jar.jar
```

This will submit a job running the `ace:exam_jar.jar` program on the `cluster-bc3d` cluster.

---

### Real World Scenario

### Spark for Machine Learning

Retailers collect large volumes of data about shoppers' purchases, and this is especially helpful for understanding customers' preferences and interests. The transaction processing systems that collect much of this data are not designed to analyze large volumes of data. For example, if retailers wanted to recommend products to customers based on their interests, they could build machine learning models trained on their sales data. Spark has a machine learning library, called MLlib, that is designed for just this kind of problem. Engineers can export data from transaction processing systems, load it into Spark, and then apply a variety of machine learning algorithms, such as clustering and collaborative filtering, for recommendations. The output of these models includes products that are likely to be of interest to particular customers. It's applications like these that drive the adoption of Spark and other analytics platforms.

---

![Snapshot of serverless options allow you to run jobs without configuring clusters.](../images/c12f036.png)


[**FIGURE 12.36**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0036) Serverless options allow you to run jobs without configuring clusters.

## Managing Cloud Storage

In [Chapter 11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml), you saw how to use life cycle management policies to automatically change a bucket's storage class. For example, you could create a policy to change a regional storage class bucket to a nearline bucket after 90 days. There may be times, however, when you would like to manually change a bucket's storage class. In those cases, you can use the `gsutil rewrite` command and specify the `-s` flag. Here's an example:

```
gsutil rewrite -s [STORAGE_CLASS] gs://[PATH_TO_OBJECT]
```

Here, *`[STORAGE_CLASS]`* is the new storage class.

Another common task with Cloud Storage is moving objects between buckets. You can do this using the `gsutil mv` command. The form of the command is as follows:

```
gsutil mv gs://[SOURCE_BUCKET_NAME]/[SOURCE_OBJECT_NAME] \ gs://[DESTINATION_BUCKET_NAME]/[DESTINATION_OBJECT_NAME]
```

Here, *`[SOURCE_BUCKET_NAME]`* and *`[SOURCE_OBJECT_NAME]`* are the original bucket name and filename, and *`[DESTINATION_BUCKET_NAME]`* and *`[DESTINATION_OBJECT_NAME]`* are the target bucket and filename, respectively.

The `move` command can also be used to rename an object, similar to the `mv` command in Linux. For an object in Cloud Storage, you can use this command:

```
gsutil mv gs://[BUCKET_NAME]/[OLD_OBJECT_NAME] \gs://[BUCKET_NAME]/[NEW_OBJECT_NAME]
```

You can also use the console to perform an array of operations (see [Figure 12.37](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#c12-fig-0037)), including:

- Editing access
- Editing labels
- Deleting a bucket
- Exporting to Cloud Pub/Sub
- Processing with Cloud Functions
- Scanning with Cloud Data Loss Protection service

Google Cloud has added a gcloud storage command to the gcloud utility. It has similar functionality to gsutil and is generally faster for both uploads and downloads.

![Snapshot of operations you can perform on buckets in Cloud Storage](../images/c12f037.png)


[**FIGURE 12.37**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml#R_c12-fig-0037) Operations you can perform on buckets in Cloud Storage

## Summary

In this chapter, you learned how to perform basic deployment and management tasks for a number of Google Cloud services, including Cloud SQL, Cloud Datastore, BigQuery, Bigtable, Cloud Spanner, Cloud Pub/Sub, Cloud Dataproc, and Cloud Storage. You have seen how to use the console and command-line tools. While `gcloud` is often used, several of the services have their own command-line tools. There was some discussion of how to create database structures, insert data, and query that data in the various database services. We also discussed basic Cloud Storage management operations, such as moving and renaming objects.

## Exam Essentials

- **Understand how to initialize Cloud SQL and Cloud Spanner.**   Cloud SQL and Cloud Spanner are the two managed relational databases for transaction processing systems. BigQuery is an analytical database designed for data warehouse and analytics. Understand the need to create databases and tables. Know that SQL is used to query these databases.
- **Understand how to initialize Cloud Firestore and Cloud Bigtable.**   These are two NoSQL offerings. You can add small amounts of data to Cloud Firestore through the console and query it with a SQL-like language called GQL. Cloud Bigtable is a wide-column database that does not support SQL. Bigtable is managed with the `cbt` command-line tool.
- **Know how to export data from BigQuery, estimate the cost of a query, and monitor jobs in BigQuery.**   BigQuery is designed to work with petabyte-scale data warehouses. SQL is used to query data. Know how to export data using the console. Understand that the `bq` command line, not `gcloud`, is the tool for working with BigQuery from the command line.
- **Know how to convert Cloud Storage bucket storage classes.**   Life cycle policies can change storage classes of buckets when events occur, such as a period of time passes. Know that `gsutil rewrite` is used to change the storage class of a bucket interactively. Know how to use the console and the command line to move and rename objects.
- **Understand that Pub/Sub is a message queue.**   Applications write data to topics, and applications receive messages through subscriptions to topics. Subscriptions can be push or pull. Unread messages have a retention period after which they are deleted.
- **Understand that Cloud Dataproc is a managed Spark and Hadoop service.**   These platforms are used for big data analytics, machine learning, and large-scale batch jobs, such as large volume extraction, transformation, and load operations. Spark is a good option for analyzing transaction data, but data must be loaded into Spark from its source system.
- **Know the four command-line tools: `gcloud`, `gsutil`, `bq`, and `cbt`.**   `gcloud` is used for most products but not all. `gsutil` and the newer gcloud storage commands are used to work with Cloud Storage from the command line. If you want to work with BigQuery from the command line, you need to use `bq`. To work with Bigtable, you use the `cbt` command.

## Review Questions

You can find the answers in the Appendix.

1. Cloud SQL is a fully managed relational database service, but database administrators still have to perform some tasks. Which of the following tasks do Cloud SQL users need to perform?
   1. Applying security patches
   2. Performing regularly scheduled backups
   3. Creating databases
   4. Tuning the operating system to optimize Cloud SQL performance
2. Which of the following commands is used to create a backup of a Cloud SQL database?
   1. `gcloud sql backups create`
   2. `gsutil sql backups create`
   3. `gcloud sql create backups`
   4. `gcloud sql backups export`
3. Which of the following commands will run an automatic backup at 3:00 a.m. on an instance called `ace-exam-mysql`?
   1. `gcloud sql instances patch ace-exam-mysql \--backup-start-time 03:00`
   2. `gcloud sql databases patch ace-exam-mysql \--backup-start-time 03:00`
   3. `cbt sql instances patch ace-exam-mysql \--backup-start-time 03:00`
   4. `bq gcloud sql instances patch ace-exam-mysql \--backup-start-time 03:00`
4. What is the query language used by Firestore in Datastore mode?
   1. SQL
   2. MDX
   3. GQL
   4. DataFrames
5. What is the correct command-line structure to export data from Firestore?
   1. `gcloud firestore export collection gs://[BUCKET_NAME]`
   2. `gcloud firestore dump collection gs://[BUCKET_NAME]`
   3. `gcloud firestore export gs://[BUCKET_NAME]`
   4. `gcloud firestore dump gs://[BUCKET_NAME]`
6. When you enter a query into the BigQuery query form, BigQuery analyzes the query and displays an estimate of what metric?
   1. Time required to enter the query
   2. Cost of the query
   3. Amount of data scanned
   4. Number of bytes passed between servers in the BigQuery cluster
7. You want to get an estimate of the volume of data scanned by BigQuery from the command line. Which option shows the command structure you should use?
   1. `gcloud BigQuery query estimate [SQL_QUERY]`
   2. `bq --location=[LOCATION] query --use_legacy_sql=false \--dry_run [SQL_QUERY]`
   3. `gsutil --location=[LOCATION] query --use_legacy_sql=false \--dry_run [SQL_QUERY]`
   4. `cbt BigQuery query estimate [SQL_QUERY]`
8. You are using Cloud Console and want to check on some jobs running in BigQuery. You navigate to the BigQuery part of the console. Which menu item would you click to view jobs?
   1. Personal History or Project History.
   2. Active Jobs.
   3. My Jobs.
   4. You can't view job status in the console; you have to use `bq` on the command line.
9. You want to estimate the cost of running a BigQuery query. What two services within Google Cloud will you need to use?
   1. BigQuery and Billing
   2. Billing and Pricing Calculator
   3. BigQuery and Pricing Calculator
   4. Billing and bq command
10. You have just created a Cloud Spanner instance. You have been tasked with creating a way to store data about a product catalog. What is the next step after creating a Cloud Spanner instance that you would perform to enable you to load data?
    1. Run `gcloud spanner update-security-patches`.
    2. Create a database within the instance.
    3. Create tables to hold the data.
    4. Use the Cloud Spanner console to import data into tables created with the instance.
11. You have created a Cloud Spanner instance and database. According to Google best practices, how often should you update VM packages using `apt-get`?
    1. Every 24 hours.
    2. Every 7 days.
    3. Every 30 days.
    4. Never; Cloud Spanner is a managed service.
12. Your software team is developing a distributed application and wants to send messages from one application to another. Once the consuming application reads a message, it should be deleted. You want your system to be robust to failure, so messages should be available for at least three days before they are discarded. Which Google Cloud service is best designed to support this use case?
    1. Bigtable
    2. Dataproc
    3. Cloud Pub/Sub
    4. Cloud Spanner
13. Your manager asks you to set up a bare-bones Pub/Sub system as a sandbox for new developers to learn about messaging systems. What are the two resources within Pub/Sub you will need to create?
    1. Topics and tables
    2. Topics and databases
    3. Topics and subscriptions
    4. Tables and subscriptions
14. Your company is launching an IoT service and will receive large volumes of streaming data. You have to store this data in Bigtable. You want to explore the Bigtable environment from the command line. What command would you run to ensure you have command-line tools installed?
    1. `apt-get install bigtable-tools`
    2. `apt-get install cbt`
    3. `gcloud components install cbt`
    4. `gcloud components install bigtable-tools`
15. You need to create a table called `iot-ingest-data` in Bigtable. What command would you use?
    1. `cbt createtable iot-ingest-data`
    2. `gcloud bigtable tables create ace-exam-bt-table`
    3. `gcloud bigtable create tables ace-exam-bt-table`
    4. `gcloud create ace-exam-bt-table`
16. Cloud Dataproc is a managed service for which two big data platforms?
    1. Spark and Cassandra
    2. Spark and Hadoop
    3. Hadoop and Cassandra
    4. Spark and TensorFlow
17. Your department has been asked to analyze large batches of data every night. The jobs will run for about three to four hours. You want to shut down resources as soon as the analysis is done, so you decide to write a script to create a Dataproc cluster every night at midnight. What command would you use to create a cluster called `spark-nightly-analysis` in the `us-west2-a` zone?
    1. `bq dataproc clusters create spark-nightly-analysis \--zone us-west2-a`
    2. `gcloud dataproc clusters create spark-nightly-analysis \--zone us-west2-a`
    3. `gcloud dataproc clusters spark-nightly-analysis \--zone us-west2-a`
    4. None of the above
18. You have a number of buckets containing old data that is hardly ever used. You don't want to delete it, but you want to minimize the cost of storing it. You decide to change the storage class to Coldline for each of those buckets. What is the command structure that you would use?
    1. `gcloud rewrite -s [STORAGE_CLASS] gs://[PATH_TO_OBJECT]`
    2. `gsutil rewrite -s [STORAGE_CLASS] gs://[PATH_TO_OBJECT]`
    3. `cbt rewrite -s [STORAGE_CLASS] gs://[PATH_TO_OBJECT]`
    4. `bq rewrite -s [STORAGE_CLASS] gs://[PATH_TO_OBJECT]`
19. You want to rename an object stored in a bucket. What command structure would you use?
    1. `gsutil cp gs://[BUCKET_NAME]/[OLD_OBJECT_NAME] \gs://[BUCKET_NAME]/[NEW_OBJECT_NAME]`
    2. `gsutil mv gs://[BUCKET_NAME]/[OLD_OBJECT_NAME] \gs://[BUCKET_NAME]/[NEW_OBJECT_NAME]`
    3. `gsutil mv gs://[OLD_OBJECT_NAME] gs://[NEW_OBJECT_NAME]`
    4. `gcloud mv gs://[OLD_OBJECT_NAME] gs://[NEW_OBJECT_NAME]`
20. An executive in your company emails you asking about creating a recommendation system that will help sell more products. The executive has heard there are some Google Cloud solutions that may be good fits for this problem. What Google Cloud service would you recommend the executive look into?
    1. Cloud Dataproc, especially Spark and its machine learning library
    2. Cloud Dataproc, especially Hadoop
    3. Cloud Spanner, which is a global relational database that can hold a lot of data
    4. Cloud SQL, because SQL is a powerful query language