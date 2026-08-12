---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVES OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- **3.4 Deploying and implementing data solutions**

---

In this chapter, we will delve into the details of loading and moving data into various storage and processing systems in Google Cloud. We’ll start by explaining how to load and move data in Cloud Storage using the console and the command line.

The bulk of the chapter will describe how to import and export data into data storage and analysis services, including Cloud SQL, Cloud Firestore, BigQuery, Cloud Spanner, Cloud Bigtable, and Cloud Dataproc. The chapter wraps up with a look into streaming data into Cloud Pub/Sub.

## Loading and Moving Data to Cloud Storage

Cloud Storage is used for a variety of storage use cases, including long-term storage and archiving, file transfers, and data sharing. This section describes how to create storage buckets, load data into storage buckets, and move objects between storage buckets.

---

![](../images/note_13.png) Google Cloud recently introduced the gcloud storage command which has similar functionality as gsutil. gcloud stroage is generally more performant than gsutil.

### Loading and Moving Data to Cloud Storage Using the Console

Loading data into Cloud Storage is a common task that’s easily done using Cloud Console.

Navigate to the Cloud Storage page of Cloud Console. You will see a list of existing buckets and an option to create a new bucket. [Figure 13.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0001) shows a listing of buckets and the Create Bucket button above the list.

When you create a bucket, you are prompted to specify a name and a location where you want to store your data, as shown in [Figure 13.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0002). The bucket name must be globally unique. The location can be Multi-Region for highest availability and highest cost, Dual-Region for high availability and low latency across two regions, or Region, which has the lowest latency within a single region. If you choose Multi-Region, your options include United States, Europe, and Asia Pacific (see the console for the latest list of multi-regions). If you choose Dual-Region, you can specify two regions within a continent, with the current options being United States, Europe, and Asia Pacific. If you choose Region, then you can choose any one of the regions available.

![Snapshot of the first step in loading data into Cloud Storage is to create a bucket.](../images/c13f001.png)


[**FIGURE 13.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0001) The first step in loading data into Cloud Storage is to create a bucket.

![Snapshot of defining a regional bucket in us-west1](../images/c13f002.png)


[**FIGURE 13.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0002) Defining a regional bucket in us-west1


---

![](../images/note_13.png) Remember that buckets are regional resources, and buckets are replicated across zones in the region.

---

Next, you will need to choose your storage class (see [Figure 13.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0003)). The options are Standard, which is best for short-term storage and frequently accessed objects; Nearline for objects accessed less than once every 30 days; Coldline storage for objects accessed less than once every 90 days; and Archive, which is used for objects accessed less than once per year.

![Snapshot of choosing a storage class and access control method](../images/c13f003.png)


[**FIGURE 13.3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0003) Choosing a storage class and access control method

Here you will also need to decide how you want to control access to the bucket. Since buckets are web addressable, you can allow anyone with the URL to your bucket to access the contents of that bucket. Google Cloud gives you the option of explicitly preventing this kind of public access by providing the Enforce Public Access Prevention On This Bucket option.

Google Cloud originally used access control lists on buckets to manage access to buckets. This is now called the Fine-grained access option, and it allows you to specify access controls on individual objects as well as on buckets. Although fine-grained access is still available, the preferred option is to use uniform access, in which access to objects in the bucket are controlled by bucket-level permissions managed by the IAM service. Uniform access control is the default and using it is considered a best practice.

---

![](../images/note_13.png) Google Cloud certification exams may test you on your knowledge of Google recommended practices. Using uniform access control instead of fine-grained access control is one of those recommended practices.

---

After you create a bucket, you can view the bucket’s details, as shown in [Figure 13.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0004).

![Snapshot of the Bucket Details page shows information on Objects, Configuration, Permissions, Protection, and Lifecycle.](../images/c13f004.png)


[**FIGURE 13.4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0004) The Bucket Details page shows information on Objects, Configuration, Permissions, Protection, and Lifecycle.

When you click Upload Files, you are prompted to do so using your client device’s filesystem. When you upload a folder, you are also prompted by your local operating system tools (see [Figure 13.5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0005)).

It’s easy to move objects between buckets. Just click the ellipsis at the end of a line to display a list of operations, which includes Move. Clicking Move will open the page shown in [Figure 13.6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0006).

When moving an object, you are prompted for a destination bucket and folder, as shown in [Figure 13.7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0007).

![Snapshot of upload Files prompts you for a folder using the client device’s filesystem tools.](../images/c13f005.png)


[**FIGURE 13.5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0005) Upload Files prompts you for a folder using the client device’s filesystem tools.

![Snapshot of objects can be moved by using the move command in the Operations menu.](../images/c13f006.png)


[**FIGURE 13.6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0006) Objects can be moved by using the move command in the Operations menu.

![Snapshot of when moving an object in the console, you will be prompted for a destination bucket and folder.](../images/c13f007.png)


[**FIGURE 13.7**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0007) When moving an object in the console, you will be prompted for a destination bucket and folder.

### Loading and Moving Data to Cloud Storage Using the Command Line

Loading and moving data can be done in the command line using the `gsutil` command.

To create a bucket, use the `gsutil mb` command. `mb` is short for “make bucket.”

```
gsutil mb gs://[BUCKET_NAME]/
```

Keep in mind that bucket names must be globally unique. To create a bucket named `ace-exam-bucket1`, use the following command:

```
gsutil mb gs://ace-exam-bucket1/
```

To upload a file from your local device or a Google Cloud virtual machine (VM), you can use the `gsutil cp command` to copy files. The command is as follows:

```
gsutil cp [LOCAL_OBJECT_LOCATION] gs://[DESTINATION_BUCKET_NAME]/
```

For example, to copy a file called `README.txt` from `/home/mydir` to the bucket `ace-exam-bucket1`, you’d execute the following command from your client device command line:

```
gsutil cp /home/mydir/README.txt gs://ace-exam-bucket1/
```

Similarly, if you’d like to download a copy of your data from a Cloud Storage bucket to a directory on a VM, you could log into the VM using SSH and issue a command such as this:

```
gsutil cp gs://ace-exam-bucket1/README.txt /home/mydir/
```

In this example, the source object is on Cloud Storage, and the target file is on the VM from which you are running the command.

The `gsutil` tool has a `move` command; its structure is as follows:

```
gsutil mv gs://[SOURCE_BUCKET_NAME]/[SOURCE_OBJECT_NAME] \ gs://[DESTINATION_BUCKET_NAME]/[DESTINATION_OBJECT_NAME]
```

To move the `README.txt` file from `ace-exam-bucket1` to `ace-exam-bucket2` and keep the same filename, you’d use this command:

```
gsutil mv gs://ace-exam-bucket1/README.txt  gs://ace-exam-bucket2/
```

## Importing and Exporting Data

As a Cloud Engineer, you may need to perform bulk data operations, such as importing and exporting data from databases. These operations are done with command-line tools and sometimes the console. We will not look into how to programmatically insert data into databases; that is more of an application developer and database administrator task.

### Importing and Exporting Data: Cloud SQL

To export a Cloud SQL database using the console, navigate to the Cloud SQL page of the console to list database instances, as shown in [Figure 13.8](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0008).

![Snapshot of listing of database instances on the Cloud SQL page of the console](../images/c13f008.png)


[**FIGURE 13.8**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0008) Listing of database instances on the Cloud SQL page of the console

Open the Instance Details page by double-clicking the name of the instance (see [Figure 13.9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0009)).

Select the Export tab to open the Export Data page. You will need to specify a bucket in which to store the backup file (see [Figure 13.10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0010)).

You will also need to choose SQL or CSV output. The SQL output is useful if you plan to import the data to another relational database. CSV is a good choice if you need to move this data into a nonrelational database or other tool that is not a relational database.

After you create an export file, you can import it. Follow the same instructions as for exporting, but choose the Import option instead of the Export option. This will display the options shown in [Figure 13.11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0011). Specify the source file, the file format, and the database to import the data to.

![Snapshot of the Instance Details page has Import and Export tabs.](../images/c13f009.png)


[**FIGURE 13.9**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0009) The Instance Details page has Import and Export tabs.

![Snapshot of exporting a database requires you to specify a bucket for storing the export file and a file format.](../images/c13f010.png)


[**FIGURE 13.10**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0010) Exporting a database requires you to specify a bucket for storing the export file and a file format.

![Snapshot of importing a database requires you to specify a path to the bucket and object storing the export file, a file format, and a target database within the instance.](../images/c13f011.png)


[**FIGURE 13.11**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0011) Importing a database requires you to specify a path to the bucket and object storing the export file, a file format, and a target database within the instance.

You can also create, import, and export a database using the command line. Use the `gsutil` command to create a bucket:

```
gsutil mb gs://ace-exam-bucket1/
```

You need to ensure that the service account can write to the bucket, so get the name of the service account by describing the instance with the following command:

```
gcloud sql instances describe [INSTANCE_NAME]
```

In this example, this command would be as follows:

```
gcloud sql instances describe ace-exam-mysql1
```

This command will produce a detailed listing about the instance. See [Figure 13.12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0012) for an example of the output.

![Snapshot of details about a database instance generated by the gcloud sql instances describe command](../images/c13f012.png)


[**FIGURE 13.12**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0012) Details about a database instance generated by the `gcloud sql instances describe` command

You can create an export of a database using this command:

```
gcloud sql export sql [INSTANCE_NAME]
                  gs://[BUCKET_NAME]/[FILE_NAME] \
                   --database=[DATABASE_NAME]
```

For example, the following command will export the MySQL database to a SQL dump file written to the `ace-exam-bucket1` bucket:

```
gcloud sql export sql ace-exam-mysql1 \ gs://ace-exam-buckete1/ace-exam-mysqlexport.sql \ 
                   --database=mysql
```

If you prefer to export to a CSV file, you will change `sql` to `csv` in the previous command. Here’s an example:

```
gcloud sql export csv ace-exam-mysql1 \ gs://ace-exam-buckete1/ace-exam-mysql-export.csv \
                   --database=mysql
```

Importing to a database uses a similarly structured command:

```
gcloud sql import sql [INSTANCE_NAME] \ gs://[BUCKET_NAME]/[IMPORT_FILE_NAME] \
                   --database=[DATABASE_NAME]
```

Using the example database, bucket, and export file, you can import the file using this command:

```
gcloud sql import sql ace-exam-mysql1 \ gs://ace-exam-buckete1/ace-exam-mysql-export.sql \
                   --database=mysql
```

### Importing and Exporting Data: Cloud Firestore

To export data from Cloud Firestore in Native mode, you can use this command:

```
gcloud firestore export gs://${BUCKET}
```

Importing and exporting data from Firestore in Datastore mode is done through the command line. Datastore mode uses a namespace data structure to group entities that are exported. You will need to specify the name of the namespace used by the entities you are exporting. The default namespace is simply `(default)`.

The Cloud Datastore `export` command is as follows:

```
gcloud datastore export --namespaces="(default)" gs://${BUCKET}
```

You can export to a bucket called `ace-exam-datastore1` using this command:

```
gcloud datastore export --namespaces="(default)" gs://ace-exam-datastore1
```

The Cloud Datastore `import` command is as follows:

```
gcloud datastore import gs://${BUCKET}/[PATH]/[FILE].overall_export_metadata
```

The export process will create a folder named `ace-exam-datastore1` using the data and time of the export. The folder will contain a metadata file and a folder containing the exported data. The metadata filename will use the same date and time used for the containing folder. The data folder will be named after the namespace of the exported Datastore database. An example import command is as follows:

```
gcloud datastore import gs://ace-exam-datastore1/2018-12-20T19:13:55_64324/2018-12-20T19:13:55_64324.overall_export_metadata
```

### Importing and Exporting Data: BigQuery

BigQuery users can export and import tables using Cloud Console and the command line.

To export a table using the console, navigate to the BigQuery console interface. Under Resources, open the data set containing the table you want to export. Click the table name to list the table description, as shown in [Figure 13.13](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0013). Notice the Export option in the upper right.

At the far right, click Export to display a list of four export locations: Google Sheets, Google Cloud Storage, Looker Studio (formerly Data Studio), which is an analysis tool in Google Cloud, or Scanning with Data Loss Prevention service (see [Figure 13.14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0014)).

Selecting Cloud Storage displays the options shown in [Figure 13.15](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0015). Enter the bucket name in which you want to store the export file. Choose a file format. The options are CSV, Avro, and JSON. Choose a compression type. The options are None or Gzip for CSV and Deflate and Snappy for Avro.

![Snapshot of detailed list of a BigQuery table](../images/c13f013.png)


[**FIGURE 13.13**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0013) Detailed list of a BigQuery table

![Snapshot of choosing a target location for a BigQuery export](../images/c13f014.png)


[**FIGURE 13.14**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0014) Choosing a target location for a BigQuery export


---

### File Formats

BigQuery offers several export file options. CSV, short for comma-separated values, is a human-readable format suitable for small data sets that will be imported into tools that only support the CSV format. CSV is not optimized for storage, so it does not compress or use a more efficient encoding than text. It’s not the best option when exporting large data sets.

JSON is also a human-readable format that has advantages and disadvantages similar to CSV. One difference is that JSON includes schema information with each record, whereas CSV uses an optional header row with column names at the beginning of the file to describe the schema.

Gzip is a widely used lossless compression utility.

Avro is a compact binary format that supports complex data structures. When data is saved in the Avro format, a schema is written to the file along with data. Schemas are defined in JSON. Avro is a good option for large data sets, especially when importing data into other applications that read the Avro format, including Apache Spark, which is available as a managed service in Cloud Dataproc. Avro files can be compressed using either the deflate or the Snappy utility. Deflate produces smaller compressed files, but Snappy is faster.

---

![Snapshot of specifying the output parameters for a BigQuery export operation](../images/c13f015.png)


[**FIGURE 13.15**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0015) Specifying the output parameters for a BigQuery export operation

To export data from the command line, use the `bq extract` command. The structure is as follows:

```
bq extract --destination_format [FORMAT] --compression 
[COMPRESSION_TYPE] --field_delimiter [DELIMITER] --print_header 
[BOOLEAN] [PROJECT_ID]:[DATASET].[TABLE] gs://[BUCKET]/[FILENAME]
```

Here’s an example:

```
bq extract --destination_format CSV --compression GZIP 'mydataset.mytable' \ gs://example-bucket/myfile.zip
```

---

![](../images/note_13.png) Remember, the command-line tool for working with BigQuery is `bq`, not `gcloud`.

---

To import data into BigQuery, navigate to the BigQuery console page and select a dataset you’d like to import data into. Click a dataset and then select Create Table, as shown in [Figure 13.16](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0016).

The Create Table page has several parameters, including an optional source table, a destination project, the dataset name, the table type, and the table name (see [Figure 13.17](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0017)).

The Create Table From field indicates where to find the source data, if any. This field provides a way to create a table based on data in an existing table, but defaults to an empty table (see [Figure 13.18](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0018)).

You will also need to specify the file format of the file that will be imported. The options include CSV, JSONL (Newline Delimited JSON), Avro, Parquet, ORC, and Cloud Datastore Backup (see [Figure 13.19](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0019)).

![Snapshot of when viewing a data set, you have the option to create a table.](../images/c13f016.png)


[**FIGURE 13.16**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0016) When viewing a data set, you have the option to create a table.

![Snapshot of creating a table in BigQuery](../images/c13f017.png)


[**FIGURE 13.17**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0017) Creating a table in BigQuery

![Snapshot of data can be imported from multiple kinds of locations.](../images/c13f018.png)


[**FIGURE 13.18**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0018) Data can be imported from multiple kinds of locations.

![Snapshot of file format options for importing](../images/c13f019.png)


[**FIGURE 13.19**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0019) File format options for importing

Provide destination information, including project, data set name, table type, and table name. Table type may be Native type or an external table. If the table is external, the data is kept in the source location, and only metadata about the table is stored in BigQuery. This type is used when you have large data sets and do not want to load them all into BigQuery.

After specifying all parameters, click Create Table to create the table and load the data.

To load data from the command line, use the `bq load` command. Its structure is as follows:

```
bq load --autodetect --source:format=[FORMAT] [DATASET].[TABLE] \[PATH_TO_SOURCE]
```

The `--autodetect` parameter has `bq load` automatically detect the table schema from the source file. An example command is as follows:

```
bq load --autodetect --source:format=CSV mydataset.mytable \ gs://ace-exam-biquery/mydata.csv
```

### Importing and Exporting Data: Cloud Spanner

Cloud Spanner users can import and export data using Cloud Console.

To export data from Cloud Spanner, navigate to the Cloud Spanner section of the console. You will see a list of Spanner instances, as shown in [Figure 13.20](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0020).

![Snapshot of listing of Spanner instances](../images/c13f020.png)


[**FIGURE 13.20**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0020) Listing of Spanner instances

Click the name of the instance that is the source of data to export. This will show the Instance Details page (see [Figure 13.21](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0021)).

Click Export to display the Export options, as shown in [Figure 13.22](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0022). You will need to enter a destination bucket, the database to export, and a region to run the job. Notice that you must confirm that you understand there will be charges for running Cloud Dataflow and that there may be data egress charges for data sent between regions.

To import data, click Import to display the Import page (see [Figure 13.23](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0023)). You will need to specify a source bucket, a destination database, and a region to run a job.

![Snapshot of import/Export page](../images/c13f021.png)


[**FIGURE 13.21**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0021) Import/Export page

![Snapshot of export options for Cloud Spanner](../images/c13f022.png)


[**FIGURE 13.22**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0022) Export options for Cloud Spanner

![Snapshot of import options for Cloud Spanner](../images/c13f023.png)


[**FIGURE 13.23**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0023) Import options for Cloud Spanner

Cloud Spanner does not have a `gcloud` command to export data, but you can use Dataflow to export data. The details of constructing Dataflow jobs is outside the scope of this section. For more details, see the Cloud Dataflow documentation at `https://cloud.google.com/dataflow/docs`.

### Exporting Data from Cloud Bigtable

Cloud Bigtable supports exporting data through the console. Navigate to the Bigtable console and select Tables from the menu bar on the left. This will display an export dialog as shown in [Figure 13.24](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#c13-fig-0024).

Bigtable exports are stored in Cloud Storage and can use one of three formats: SequenceFile, Avro, or Parquet.

![Snapshot of export page for Cloud Bigtable](../images/c13f024.png)


[**FIGURE 13.24**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml#R_c13-fig-0024) Export page for Cloud Bigtable

### Importing and Exporting Data: Cloud Dataproc

Cloud Dataproc is not a database like Cloud SQL or Bigtable; rather, it is a data analysis platform. These platforms are designed more for data manipulation, statistical analysis, machine learning, and other complex operations than for data storage and retrieval. Cloud Dataproc is not designed to be a persistent store of data. For that you should use Cloud Storage or persistent disks to store the data files you want to analyze.

Cloud Dataproc does have Import and Export commands to save and restore cluster configuration data. These commands are available using `gcloud`.

The command to export a Dataproc cluster configuration is as follows:

```
gcloud dataproc clusters export [CLUSTER_NAME] \ --destination=[PATH_TO_EXPORT_FILE]
```

Here’s an example:

```
gcloud dataproc clusters export ace-exam-dataproc-cluster \ --destination=gs://ace-exam-bucket1/mydataproc.yaml
```

To import a configuration file, use the `import` command:

```
gcloud dataproc clusters import [SOURCE_FILE]
```

For example, to import the file created in the previous `export` example, use the following:

```
gcloud dataproc clusters import gs://ace-exam-bucket1/mydataproc.yaml
```

Importing and exporting data are common operations. Google Cloud provides console and command-line tools for most database services. There are also beta commands for exporting and importing cluster configuration data for Dataproc.

## Streaming Data to Cloud Pub/Sub

So far in this chapter you have spent most of your time on moving data into and around Cloud Storage, along with importing and exporting data to databases. Let’s now turn our attention to working with Cloud Pub/Sub, the messaging queue.

As a Cloud Engineer, you may need to create message queues for application developers. Although developers will most likely write services that use Pub/Sub, Cloud Engineers should be able to test Pub/Sub topics and subscriptions. We discussed how to create message queues in [Chapter 12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml), “Deploying Storage in Google Cloud.” Here our focus will be on creating messages on topics and receiving those messages through subscriptions.

The `gcloud pubsub` commands you will use are `create`, `publish`, and `pull`. To create a topic, you use the following command:

```
gcloud pubsub topics create [TOPIC_NAME]
```

The command to create a subscription is as follows:

```
gcloud pubsub subscriptions create --topic [TOPIC_NAME] [SUBSCRIPTION_NAME]
```

For example, to create a topic called `ace-exam-topic1` and a subscription to that topic called `ace-exam-sub1`, you can use these commands:

```
gcloud pubsub topics create ace-exam-topic1 gcloud pubsub subscriptions create --topic=ace-exam-topic1 ace-exam-sub1
```

Now, to test whether the message queue is working correctly, you can send data to the topic using the following command:

```
cloud pubsub topics publish [TOPIC_NAME] --message [MESSAGE]
```

and then read that message from the subscription using the following:

```
gcloud pubsub subscriptions pull --auto-ack [SUBSCRIPTION_NAME]
```

To write a message to the topic and read it from the subscription you just created, you can use the following:

```
gcloud pubsub topics publish ace-exam-topic1 \ ––message "first ace exam message" gcloud pubsub subscriptions pull ––auto-ack ace-exam-sub1
```

---

### Real World Scenario

### Decoupling Services Using Message Queues

One of the challenges with distributed systems is that sometimes one service cannot keep up with the inflow of data. This can create a backlog in services that depend on the lagging service.

For example, a sudden spike in traffic on a retail site may put a high load on an inventory tracking service, which updates inventory as customers add or remove items from their baskets. The inventory program may be slow to respond to a service that added an item to the cart. If that service is waiting for a response from the inventory service, it too will be delayed. This kind of synchronous communication is problematic when distributed systems are under load.

A better option is to decouple the direct connection between services. For example, the user interface could write a message to a Pub/Sub topic each time an item is added or removed from a customer’s basket. The inventory management service can subscribe to this topic and update the inventory system as new messages come in. If the inventory system slows down, it will not affect the user interface because it is writing to a Pub/Sub topic, which can scale along with the load generated by the user interface.

---

## Summary

In this chapter, we looked at the different ways you can load data into storage, database, and message queue systems. Cloud Storage is organized around objects in buckets. The `gsutil` command and Cloud Console can be used to upload data as well as move it between buckets. You saw that the `gsutil cp` command can be used to copy files between Cloud Storage and VMs.

The database services provide import and export utilities. Each supports a variety of file formats.

Cloud Pub/Sub can be used to decouple applications and improve resiliency to spikes in load. You saw how to create a topic and subscriptions and how to push data to the message queue, where it can be read by subscribers.

Know that Cloud Spanner uses the Dataflow service for importing and exporting. There can be additional charges when using Dataflow and moving data between regions.

## Exam Essentials

- **Know how to load data into and move data around Cloud Storage.**   Cloud Storage is widely used for a variety of use cases, including long-term storage and archiving, file transfers, and data sharing. Understand the structure of `gsutil` commands, which is different from `gcloud`. `gsutil` commands start with `gsutil` followed by an operation, such as `copy` or `make bucket`. Be sure to know the syntax of the copy (`cp`), move (`mv`), and make bucket (`mb`) commands. You can copy files from Cloud Storage to VMs, and vice versa. Also, know that the `gsutil acl ch -u` command is used to change permissions on objects. You can use the gsutil acl ch command to change permissions on a Cloud Storage bucket.
- **Understand how import and export work with Cloud SQL.**   Importing and exporting data from databases are common operations. You can perform imports and exports from the console and from the command line.
- **Know that you can export entities from a Cloud Firestore.**   Exports and imports are done at the database level when in Native mode and at the level of namespaces when the database is in Datastore mode.
- **Understand how to export and import data from BigQuery.**   BigQuery has a range of options for the source of data to import. Data can be compressed when exported to save on space. BigQuery can export data in multiple formats, including CSV, JSON, and Avro. Know that the `bq` command is used for importing and exporting from the command line.
- **Know that Pub/Sub is used to send messages between services.**   Pub/Sub allows for greater resiliency to fluctuations in load. If one service lags, its work can accumulate in a Pub/Sub queue without forcing the service that generates that data to wait.

## Review Questions

You can find the answers in the Appendix.

1. Which of the following commands is used to create buckets in Cloud Storage?
   1. `gcloud storage create buckets`
   2. `gsutil storage buckets create`
   3. `gsutil mb`
   4. `gcloud mb`
2. You need to copy files from your local device to a bucket in Cloud Storage. What command would you use? Assume you have Cloud SDK installed on your local computer.
   1. `gsutil copy`
   2. `gsutil cp`
   3. `gcloud cp`
   4. `gcloud storage objects copy`
3. You are migrating a large number of files from a local storage system to Cloud Storage. You want to use the Cloud Console instead of writing a script. Which of the following Cloud Storage operations can you perform in the console?
   1. Upload files only
   2. Upload folders only
   3. Upload files and folders
   4. Compare local files with files in the bucket using the `diff` command
4. A software developer asks for your help exporting data from a Cloud SQL database. The developer tells you which database to export and which bucket to store the export file in, but hasn’t mentioned which file format should be used for the export file. What are the options for the export file format?
   1. CSV and XML
   2. CSV and JSON
   3. JSON and SQL
   4. CSV and SQL
5. A database administrator has asked for an export of a MySQL database in Cloud SQL. The database administrator will load the data into another relational database and would like to do it with the least amount of work. Specifically, the loading method should not require the database administrator to define a schema. What file format would you recommend for this task?
   1. SQL
   2. CSV
   3. XML
   4. JSON
6. Which command will export a MySQL database called `ace-exam-mysql1` to a file called `ace-exam-mysql-export.sql` in a bucket named `ace-exam-buckete1`?
   1. `gcloud storage export sql ace-exam-mysql1 \ gs://ace-exam-buckete1/ace-exam-mysql-export.sql \ ––database=mysql`
   2. `gcloud sql export ace-exam-mysql1 \gs://ace-exam-buckete1/ace-exam-mysql-export.sql \ ––database=mysql`
   3. `gcloud sql export sql ace-exam-mysql1 \gs://ace-exam-buckete1/ace-exam-mysql-export.sql \ ––database=mysql`
   4. `gcloud sql export sql ace-exam-mysql1 \gs://ace-exam-mysql-export.sql/ace-exam-buckete1/ \ ––database=mysql`
7. Which of the following file formats is not an option for an export file when exporting from BigQuery?
   1. CSV
   2. XML
   3. Avro
   4. JSON
8. Which of the following file formats is not supported when importing data into BigQuery?
   1. CSV
   2. Parquet
   3. Avro
   4. YAML
9. You have received a large data set from an Internet of Things (IoT) system. You want to use BigQuery to analyze the data. What command-line command would you use to make data available for analysis in BigQuery?
   1. `bq load ––autodetect ––source:format=[FORMAT] \[DATASET].[TABLE]` `[PATH_TO_SOURCE]`
   2. `bq import ––autodetect ––source:format=[FORMAT] \[DATASET].[TABLE] [PATH_TO_SOURCE]`
   3. `gloud BigQuery load ––autodetect ––source:format=[FORMAT] \[DATASET].[TABLE] [PATH_TO_SOURCE]`
   4. `gcloud BigQuery load ––autodetect ––source:format=[FORMAT] \[DATASET].[TABLE] [PATH_TO_SOURCE]`
10. You have set up a Cloud Spanner process to export data to Cloud Storage. You notice that each time the process runs you incur charges for another Google Cloud service, which you think is related to the export process. What other Google Cloud service might be incurring charges during the Cloud Spanner export?
    1. Dataproc
    2. Dataflow
    3. Firestore
    4. `bq`
11. As a developer on a project using Bigtable for an IoT application, you will need to export data from Bigtable to make some data available for analysis with another tool. What would you use to export the data, assuming you want to minimize the amount of effort required on your part?
    1. A Java program designed for importing and exporting data from Bigtable
    2. `gcloud bigtable table export`
    3. `bq bigtable table export`
    4. An import tool provided by the analysis tool
12. You have just exported from a Dataproc cluster. What have you exported?
    1. Data in Spark DataFrames
    2. All tables in the Spark database
    3. Configuration data about the cluster
    4. All tables in the Hadoop database
13. A team of data scientists has requested access to data stored in Bigtable so that they can train machine learning models. They explain that Bigtable does not have the features required to build machine learning models. Which of the following Google Cloud services are they most likely to use to build machine learning models?
    1. Firestore
    2. Dataflow
    3. Dataproc
    4. DataAnalyze
14. Which of the following is the correct command to create a Pub/Sub topic?
    1. `gcloud pubsub topics create`
    2. `gcloud pubsub create topics`
    3. `bq pubsub create topics`
    4. `cbt pubsub topics create`
15. Which of the following commands will create a subscription on the topic `ace-exam-topic1`?
    1. `gcloud pubsub create ––topic=ace-exam-topic1 ace-exam-sub1`
    2. `gcloud pubsub subscriptions create ––topic=ace-exam-topic1`
    3. `gcloud pubsub subscriptions create ––topic=ace-exam-topic1 ace-exam-sub1`
    4. `gsutil pubsub subscriptions create ––topic=ace-exam-topic1 ace-exam-sub1`
16. What is one of the direct advantages of using a message queue in distributed systems?
    1. It increases security.
    2. It decouples services, so if one lags, it does not cause other services to lag.
    3. It supports more programming languages.
    4. It stores messages until they are read by default.
17. To ensure you have installed beta `gcloud` commands, which command should you run?
    1. `gcloud components beta install`
    2. `gcloud components install beta`
    3. `gcloud commands install beta`
    4. `gcloud commands beta install`
18. What parameter is used to tell BigQuery to automatically detect the schema of a file on import?
    1. `autodetect`
    2. `autoschema`
    3. `detectschema`
    4. `dry_run`
19. The compression options Deflate and Snappy are available for what file types when exporting from BigQuery?
    1. Avro
    2. CSV
    3. XML
    4. Thrift
20. You want to read a message from a Pub/Sub topic and acknowledge reading that message in the same command. Which of the following would you use?
    1. `gcloud pubsub subscriptions pull --auto-ack`
    2. `gcloud pubsub topic pull --auto-ack`
    3. `gsutil pubsub topic pull --with-acknowledgement`
    4. `gcloud pubsub subscription pull --with-acknowledgement`