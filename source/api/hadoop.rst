Hadoop integration
==================

Introduction
------------

`Map/Reduce <https://en.wikipedia.org/wiki/MapReduce>`_ is a model for processing large amounts of data in parallel. One well-known implementation is Hadoop MapReduce.

A Map/Reduce job is divided into 2 phases:
	- Map phase
	- Reduce phase

These phases use key/value pairs as input and output.

We provide all necessary classes to integrate quasardb with Hadoop eco-system. The Map Reduce framework orchestrates splitting and distribution of Map and Reduce phases across the clsuter. Your implementation must provide map and reduce functions.

Requirements
------------

 * Java 1.6 or later.
 * Hadoop jar dependencies.


Installation
------------

The Java API package is downloadable from the quasardb download site. All information regarding the quasardb download site is in your welcome e-mail.

The archive contains a JAR named ``quasardb-java-api-master.jar`` that contains all the dependencies including the required binaries for FreeBSD, Linux and Windows. It is not necessary to download another archive to use the Hadoop integration.

You will also find 5 examples in the ``com.b14.qdb.hadoop.mapreduce.examples`` directory:

 ==================== ================================================================================================== ======================================
  Example              Description                                                                                        Input Data File
 ==================== ================================================================================================== ======================================
  cards                Counts all card values for a card suit.                                                            src/test/resources/cardsinput.txt
  financial            Shows high/low for a day across a single stock symbol, all symbols, and a custom Writeable.        src/test/resources/NASDAQ_daily_prices_Y.csv
  standard deviation   Computes standard deviations of height for a given population.                                     src/test/resources/01_heights_weights_genders.csv
  temperature          Finds the max temperature group by year for given meteorological data.                             src/test/resources/temperatures.txt
  wordcounter          Finds number of occurrences for all words in the book "Adventures of Huckleberry Finn, Complete"   src/test/resources/huck_fin.txt
 ==================== ================================================================================================== ======================================


Package
-------

The API resides in the ``com.b14.quasardb.hadoop`` package.


Build your first Map Reduce Job
-------------------------------

This job will be called StartsWithCount. It will:
	* Read a body of text from quasardb (a pre-loaded file named hamlet.txt)
	* Split the text into tokens
	* For each first letter in the text, sum up all occurrences
	* Output to quasardb

So we'll need to:
	1. Configure the Job: Specify Input, Output, Mapper, Reducer and Combiner
	2. Implement Mapper: Input is text and we'll need to tokenize the text and emit first character with a count of 1 - <token, 1>
	3. Implement Reducer: Sum up counts for each letter and write out the result to quasardb
	4. Run the job.



Configure the Job
^^^^^^^^^^^^^^^^^^

Configuration Class
~~~~~~~~~~~~~~~~~~~

The Configuration class encapsulates how to connect with one or more quasardb nodes (hostname and port). You must specify a keys generator from one of the built-in generators:

 =================================================================== =======================================
  Keys Generator                                                      Processes
 =================================================================== =======================================
  com.b14.qdb.hadoop.mapreduce.keysgenerators.AllKeysGenerator        All keys on the cluster
  com.b14.qdb.hadoop.mapreduce.keysgenerators.PrefixedKeysGenerator   All keys matching the provided prefix
  com.b14.qdb.hadoop.mapreduce.keysgenerators.ProvidedKeysGenerator   All keys matching the provided alias
 =================================================================== =======================================


You may also develop your own keys generator by implementing the com.b14.qdb.hadoop.mapreduce.keysgenerators.IKeysGenerator class, such as the example below::

	Configuration conf = new Configuration();
	conf.set(QuasardbJobConf.QDB_NODES, "127.0.0.1:2836");
	conf = QuasardbJobConf.addLocation(conf, new QuasardbNode("127.0.0.1", 2836));
	ProvidedKeysGenerator providedKeysGenerator = new ProvidedKeysGenerator();
	providedKeysGenerator.init("MY_PREFIX");
	conf = QuasardbJobConf.setKeysGenerator(conf, providedKeysGenerator);

Job Class
~~~~~~~~~

The Job class encapsulates and controls execution of a job. ::

	Job job = Job.getInstance(getConf(), "StartsWithCount");

A job is packaged within a jar file. The Hadoop Framework distributes the jar on your behalf but needs to know which jar file to distribute. The easiest way to specify the jar that your job resides in is by calling job.setJarByClass::

	job.setJarByClass(getClass());

Hadoop will locate the jar file that contains the provided class. Then you need to specify the input type::

	job.setInputFormatClass(QuasardbInputFormat.class);

.. note::
	- Key type for InputFormat must be a plain text (see org.apache.hadoop.io.Text)
	- Value type can be anything you want

Then you need to specify the output type::

	job.setOutputFormatClass(QuasardbOutputFormat.class);

.. note::
	- Key type for OutputFormat must be a plain text (see org.apache.hadoop.io.Text)
	- Value type can be anything you want

Mapper, Reducer and Combiner Classes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

At a minimum you will need implement these classes. Mappers and Reducer usually have same output key::

	job.setMapperClass(StartsWithCountMapper.class);
	job.setReducerClass(StartsWithCountReducer.class);
	job.setCombinerClass(StartsWithCountReducer.class);

Finally, your configuration ends with::

	job.waitForCompletion(true);

waitForCompletion submits the job and waits for completion. The boolean parameter specifies whether output should be written to console. If the job completes successfully, true is returned, otherwise false is returned.

To sum up, here are steps to configure your mapreduce job :
	1. Chop up text files into lines
	2. Send records to mappers as key-value pairs
		* Line number and the actual value
	3. Mapper class is StartsWithCountMapper
		* Receives key-value of <IntWritable,Text>
		* Outputs key-value of <Text, IntWritable>
	4. Reducer class is StartsWithCountReducer
		* Receives key-value of <Text, IntWritable>
		* Outputs key-values of <Text, IntWritable> as text
	5. Combiner class is StartsWithCountReducer

Example Code::

	public class StartsWithCountJob extends Configured implements Tool {
		@Override
		public int run(String[] args) throws Exception {
			// configure connection to quasardb
			Configuration conf = new Configuration();
			conf.set(QuasardbJobConf.QDB_NODES, "127.0.0.1:2836");
			conf = QuasardbJobConf.addLocation(conf, new QuasardbNode("127.0.0.1", 2836));
			ProvidedKeysGenerator providedKeysGenerator = new ProvidedKeysGenerator();
			providedKeysGenerator.init("hamlet");
			conf = QuasardbJobConf.setKeysGenerator(conf, providedKeysGenerator);

			Job job = Job.getInstance(getConf(), "StartsWithCount") ;
			job.setJarByClass(getClass());

			// configure output and input source
			job.setInputFormatClass(QuasardbInputFormat.class);

			// configure mapper and reducer
			job.setMapperClass(StartsWithCountMapper.class);
			job.setCombinerClass(StartsWithCountReducer.class);
			job.setReducerClass(StartsWithCountReducer.class);

			// configure output
			job.setOutputFormatClass(QuasardbOutputFormat.class);
			job.setOutputKeyClass(Text.class);
			job.setOutputValueClass(IntWritable.class);
			return job.waitForCompletion(true) ? 0 : 1;
		}

		public static void main(String[] args) throws Exception {
			int exitCode = ToolRunner.run(new StartsWithCountJob(), args);
			System.exit(exitCode);
		}
	}


Implement Mapper Class
^^^^^^^^^^^^^^^^^^^^^^

Class has 4 Java Generics parameters
	* (1) input key (2) input value (3) output key (4) output value
	* Input and output utilizes hadoop's IO framework
		- org.apache.hadoop.io
	* Your job is to implement map() method
		- Input key and value
		- Output key and value
		- Logic is up to you
	* map() method injects Context object, use to:
		- Write output
		- Create your own counters

Example Code::

	public class StartsWithCountMapper extends Mapper<Text, Text, Text, IntWritable> {
		private final static IntWritable countOne = new IntWritable(1);
		private final Text reusableText = new Text();

		@Override
		protected void map(Text key, Text value, Context context) throws IOException, InterruptedException {
			StringTokenizer tokenizer = new StringTokenizer(value.toString());
			while (tokenizer.hasMoreTokens()) {
				reusableText.set(tokenizer.nextToken().substring(0, 1));
				context.write(reusableText, countOne);
			}
		}
	}


Implement Reducer Class
^^^^^^^^^^^^^^^^^^^^^^^

Analogous to Mapper - generic class with four types
	* (1) input key (2) input value (3) output key (4) output value
	* The output types of map functions must match the input types of reduce function (in this case Text and IntWritable)
	* Map/Reduce framework groups key-value pairs produced by mapper by key
		- For each key there is a set of one or more values
		- Input into a reducer is sorted by key
		- Known as Shuffle and Sort
	* Reduce function accepts key->setOfValues and outputs keyvalue pairs
		- Also utilizes Context object (similar to Mapper)

Example Code::

	public class StartsWithCountReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
		@Override
		protected void reduce(Text token, Iterable<IntWritable> counts, Context context) throws IOException, InterruptedException {
			int sum = 0;
			for (IntWritable count : counts) {
				sum += count.get();
			}
			context.write(token, new IntWritable(sum));
		}
	}

Reducer as a Combiner
^^^^^^^^^^^^^^^^^^^^^

You can combine data per Mapper task to reduce amount of data transferred to the Reduce phase.
	* Reducer can very often serve as a combiner (only works if reducer's output key-value pair types are the same as mapper's output types)
	* Combiners are not guaranteed to run
		- Optimization only
		- Not for critical logic


Run Your Job
^^^^^^^^^^^^

Use yarn to run your completed job::

	yarn jar qdb-api-master-tests.jar com.b14.qdb.hadoop.mapreduce.examples.wordcounter.StartsWithCountJob hamlet.txt
