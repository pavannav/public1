[00:00:00] Hello and welcome back. Let's wrap up our module by having a look at the license file, the reading file and also let's create an examples folder. So the license that I'll be applying here is just gonna be the mit license. That's an open source license. It's not a big deal. And you should actually, if you are creating this internally or if you are creating

[00:00:20] this to be a commercial module or something like this, I don't know, but you should have a look at the license here because this is also something that is important for the users of your module. So the users of our module should know under which license your module is because if they reuse that module, for example, under a GP L license

[00:00:40] and they would like to make money with something that they are reusing your module or your source code for, they would also have to make their code open source, right? So there are implications for the license and then it does make sense that you have a look at that, at least at the, at the broader level. What do you wanna do? Do you wanna make it open source entirely. Do you wanna make it a little bit more strict?

[00:01:00] Do you want to make it a like closed source or something like this? So the license is gonna determine that the license I'll be using here is just the mit license. That's a pretty permissive thing since there is nothing special in the code. Just examples. So let's copy this here. And once again, you should evaluate that which one is relevant for you based also on

[00:01:21] your user needs and on how you want to protect your module. So let's just copy this. We're gonna paste it here under the license file and we're gonna just change this to copyright. What is the 2024 right now when I'm recording? And we're just gonna add Lauro here, Miller here and then this is just specifying that this is a pretty open source.

[00:01:41] There are no restrictions here and you can use that even for your commercial purposes if you want to. But that's basically an open source license. We can have a look at the Readme file. And we are gonna say here that this module write this module managers in the creation of vpcs,

[00:02:01] vpcs and subnets allowing for the creation creation of both private and public subnets, right? So just very, very straightforward, there is nothing much happening on the module itself. Let's just put here example usage

[00:02:20] and then we're just going to add here a block of code which is going to be terraform. So I don't know if the markdown recognizes Haar configuration language. So let's just copy here from our networking and we're gonna just paste this here. So let's copy this, let's paste in the read me like so and let's remove a couple of things here just

[00:02:41] to make this a little bit of a linear example. So we have the VPC config we have the name here. That's great. So let's say here the VPC, your VPC and then we have also a Cidr block and then we have some examples here. That's already good enough for the read me. Once again, if you are making this available to others,

[00:03:01] then you should always add as much information as possible. Probably you also want to generate some tables here based on outputs and on variables as we saw when we were working with public modules. But once again, our purpose here is just to add some information, we're gonna say here networking module and that's it. So let's now create here a new folder under networking.

[00:03:23] We're gonna call this examples and then we will also have another exam, another folder under examples. And we're gonna say here, complete, right? So this will then contain and I'm not sure whether that's probably like this. Yeah, then it creates two folders here and we're gonna add under the complete. We're gonna just add here

[00:03:42] a main dot TF main dot EF where we're gonna copy the example from our networking, right? So I'm just gonna copy this here. We're gonna paste in main dot TF. And then we say here like so and then we can also add here one comment to say that public subnets

[00:04:01] are indicated by setting the public option to true. So this is perhaps what's unique in terms of this module, cyber block. We're just passing through availability zone, we're just passing through same thing for the VPC here. So the public key or the public configuration

[00:04:20] option here is perhaps what is what is mostly unique about this because there are few decisions happening behind the scenes based on this key. So we can add a comment here so that whenever users are having a look at our examples, then they would understand, OK, I can use this public key to mark a certain Subnet as public, but I believe that's good enough for now.

[00:04:42] So basically, I just wanted to cover the different things we should keep in mind as well. And when we are developing modules and these are the license file we should consider which license is relevant for us. The readme file, we should also include some description of our module and we should be more detailed, the wider the scope of the module is and the wider the user base is as well.

[00:05:03] And then we should also provide an examples folder where if the module has a lot of functionality, we can have different configurations here, different standard or common usage patterns of the module so that whenever users are exploring it, they can see practical examples of how to use it.

[00:05:21] That's great. So let's take a short break and come back in the next lecture.