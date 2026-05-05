s video



Chapters

Transcript
Search in video
Intro
0:05
Hello and welcome back. You have learned
0:07
how to write fantastic code, manage
0:10
versions, and collaborate like a pro.
0:12
But there's a crucial piece of the
0:14
puzzle that often gets overlooked.
0:17
Communication. How do you explain your
0:19
project to new contributors? How do you
0:22
provide clear instructions for setup and
0:24
usage? And how do you ensure your
0:27
project looks looks professional on
0:29
GitHub? The answer is markdown.
What is Markdown
0:32
Specifically, how you use it to craft
0:36
excellent readme files and other
0:38
documentation. Today we are diving into
0:40
the essential markdown syntax you need
0:43
and critically why good documentation
0:46
isn't just a nice to have but an
0:48
absolute necessary for any successful
0:50
project. Let's get documenting. So what
0:54
is markdown and why readme.md file? So
0:59
at its heart, markdown is a lightweight
1:01
markup language that allows you to add
1:04
formatting elements to plain text
1:06
documents. It uses a very simple and
1:09
easy to read syntax. It has designed it
1:12
was designed to be easily convertible to
1:15
HTML and many other formats. Now why is
1:18
it so popular especially with Git and
1:20
GitHub? mainly because of its
Why is Markdown so popular
1:24
simplicity. It's incredibly easy to
1:26
learn and write. Then the readability.
1:30
Even in its raw form, Markdown is very
1:34
readable. Then versatility. You can
1:37
create headings, lists, links, code
1:40
blocks, images, and more. And then
1:42
finally, readme.md standard. So on
1:45
GitHub or any other Git platforms, any
1:49
file named readme.md in the root of your
1:52
project is automatically rendered as a
1:55
formatted HTML on the repository's main
1:57
page. This makes it the go-to place for
2:01
your project's introduction.
2:03
Now, a well-crafted readme file is often
2:07
the first thing anyone sees when they
2:09
visit your repository. It's your
2:11
project's storefront. It's welcome mat
2:14
and its quick start guide all rolled
2:17
into one. Now before we dive into the
2:19
syntax, let's briefly reinforce why
2:22
bothering with good documentation is so
2:24
vital. It's not just about looking
2:26
pretty. It's about efficiency,
2:28
collaboration, and sustainability.
2:31
So the first thing we have is onboarding
2:33
new teammates. So imagine a new engineer
2:36
joining in your team. A clear readme
2:39
with setup instructions can save hours
2:42
of their time and your time explaining
2:44
those things then your future self. So
2:48
believe me 2 months from now you will
2:50
forget why you made a certain decision
2:52
or how to run that obscure script. Good
2:55
notes save you from future headaches.
2:58
Then open source contributions. If you
3:01
want people to use or contribute your
3:03
opensource project, clear documentation
3:06
is non-negotiable.
3:08
It lowers the barrier to entry. And then
3:12
project clarity. It forces you to think
3:14
through how your project works, its
3:17
features, and its purpose. This clarity
3:20
benefits everyone involved. And then
3:24
professionalism.
3:25
A project with well-maintained
3:27
documentation signals attention to
3:29
detail and a high standard of work. It's
3:32
a hallmark of professional developers.
3:35
So, think of documentation as an
3:37
investment. It pays dividends in saved
3:40
time, fewer questions, and smoother
3:43
collaboration.
3:45
Now, let's jump into a text editor and
3:48
explore the essential markdown syntax.
3:51
Uh, you can use anything you want. You
3:53
can use a VS Code, Sublime Text or
3:56
directly on GitHub's file editor, which
3:58
often has a preview mode. So in our case
4:01
we will be using this collaboration
4:03
project and for us to save some time.
4:06
I've already created this file. So this
4:08
is the naming convention readme.md. So
4:10
that's the markdown file. And this is
4:12
where you will be providing your
4:15
instructions. So like I said just to
4:18
save some time I've already included
4:21
everything here. I we will just go
4:22
through all of these. So the first we
4:24
have is your headings. So headings
4:27
structure your document. So think of
4:29
them like H1, H2 etc. in HTML. So if I
4:33
open up this file in the edit mode. So I
4:36
use this pencil icon. So here this is
4:39
how it is generally written. So a single
4:41
hash uh can be used to provide your
4:44
project title. So this would be this is
4:46
an equivalent of
4:48
H1.
4:50
Then double hash is your section heading
4:52
which is equivalent of H2.
4:55
Then three hash is a subsection which is
4:58
equivalent of H3.
5:00
This is your smaller heading which has
5:02
four hash which is equivalent of your
5:04
H4. So likewise
5:07
this will be H5
5:10
and this will be your H6.
5:13
So same as your HTML uh what we do in
5:15
HTML we use hash depending on how you
5:19
want your headings to look like. Then
5:21
you have your emphasis. So whether you
5:23
want it to be itallic, bold or strike
5:26
through. So you can either use this
5:28
single asterisk start with single
5:30
asterisk or and end with or um
5:33
underscore. So start with underscore and
5:35
end with underscore and then the text in
5:37
between. This marks it as itallic. If
5:40
you want to make it bold, you can use
5:42
double asterisk or double underscore. If
5:46
you want to make it both bold and
5:48
itallic, you can use three asterisks
5:50
beginning and ending with it.
5:52
Now if you want to make any text strike
5:55
through then you can use this tilda
5:56
symbol. So you can begin with two tilda
5:59
symbol and then end it with two tilda
6:01
symbol and this will be marked as strike
6:04
through. Now you can also create lists.
6:07
So for clear structured points. So first
6:11
we have is your unordered list. So you
6:14
can either use a hyphen or you can use
6:15
an asterisk. So here you can see hyphen
6:18
item one hyphen item two. You can also
6:20
create sub items and you can also make
6:22
use of your asterisks and this will be
6:25
your ordered list where you can see the
6:26
numeric order. So 1 2 and then sub items
6:30
as well and then three four and then so
6:32
on. Now you can also have code blocks.
6:36
So crucial for showing showing code
6:38
snippets and commands. So the first we
6:40
have is your inline code. So here like
6:43
let's say you want to show this as an
6:46
inline code then I can make use of this
6:49
um um single tick starting and ending
6:51
with it. So this will be shown as an
6:53
inline code. Now if you want to pass a
6:56
multi-line code block you can use this
6:59
um three uh back tick starting with
7:01
three back ticks and then ending it with
7:04
three back ticks. So here this is simple
7:07
Python code that I have written. Now you
7:09
can also put links. So if you want to
7:11
direct your users to external resources
7:14
or other parts of your documents, you
7:16
can provide links. So you'll have you
7:18
can you can have the text and the URL
7:21
for that particular text. So here is our
7:23
example. So visit our GitHub
7:24
repositories which is the text and this
7:27
will be linked to the URL.
7:31
You can also have images um within your
7:34
readme file. So for you know like your
7:37
screenshots or diagrams or logos. So uh
7:41
this is how you will be providing it.
7:43
Now you can link uh to images hosted
7:46
elsewhere or which images that you have
7:49
within your repository itself. For that
7:51
you will be using a relative path. Then
7:54
you have your block quotes. So if you
7:57
want quoting text often used for
7:59
warnings or important notes then you can
8:02
use this block quotes. And uh the last
8:06
one I have is your horizontal rule. So
8:09
this can be used to visually separate
8:13
sections. So here this is how we can
8:16
provide it. Now these are some of the
8:19
most common and essential markdown
8:21
elements you will use daily. There are
8:24
more but mastering these will make your
8:27
readme files look professional and be
8:29
incredibly helpful. So let me comment
8:32
this and show you the uh changes. So let
8:36
me comment and done. So you can see how
8:39
uh it is showing you different different
8:41
sizes. So based on the hash number of
8:43
hashes you have used. So this is
8:45
itallic, this is bold, this is bold and
8:48
italic and this is your strike through.
8:50
This is your unordered list. This is
8:53
your ordered list. And here is your
8:55
inline code. This becomes your
8:59
multi-line code. Uh this becomes your
9:01
link. So the text which is mapped to
9:04
your link and here will be your image.
9:07
And this is your block code. So if you
9:09
want to mark something as important, you
9:12
can use that. And then you have this
9:14
horizontal rule. So if you want to mark
9:16
a section, you can uh set that as well.
9:21
So readme files are very essential for
9:24
any project uh to provide documentation
9:28
information or instructions about how to
9:30
use that um project and many other
9:34
useful information.
9:36
Now beyond just knowing the syntax there
9:38
are few tips for crafting really
9:42
effective readme files. So have a clear
Tips
9:45
title and overview. So immediately tell
9:49
users what your project is about. Then
9:52
the table of content. So use links to
9:54
jump to sections. GitHub automatically
9:57
generates these if your if you structure
9:59
your headings well. Then installation
10:02
instructions. So clear step-by-step
10:04
commands. Then you can have usage
10:06
examples. So show how to run your code
10:09
or use your library.
10:12
Then contributing guidelines. So you
10:14
know how can others help? How can others
10:17
contribute to your repository? So maybe
10:20
you can link it to a contributing MD
10:22
file. Then you can have your license
10:24
information. So which is very crucial
10:27
for any open-source project. So you know
10:30
what is the license you are using? who
10:32
can use, who cannot use, all that
10:34
information. And then finally the
10:36
contact or support. So how users can get
10:39
help, how can they reach to you or where
10:42
they can reach out for support, all that
10:45
information.
10:46
So a good readme file anticipates
10:49
questions and provides immediate
10:51
answers, setting a project up for
10:53
success. You have just gained a super
10:56
power that goes beyond just writing
10:58
code. Effective communication through
11:01
markdown. Understanding and applying a
11:04
markdown syntax for your readme files
11:06
and other documentation is a hallmark of
11:08
a professional developer. It helps
11:10
onboard teammates, guide users, attract
11:14
contributors, and ultimately make your
11:16
project more successful and sustainable.
11:18
Whether you're working on a personal
11:20
portfolio project or contributing
11:22
contributing to a large enterprise
11:24
system, clear documentation is very
11:26
critical.
11:28
This wraps up module 4. You have learned
11:31
the essentials of GitHub collaboration
11:33
from pull requests to issues, forking
11:36
and now markdown. You are fully equipped
11:39
to participate in any modern development
11:41
team. In the next video, we will have
11:44
our fourth project which is team
11:46
collaboration simulation. If this video
11:49
helped you conquer markdown, please hit
11:52
that like button, subscribe to the
11:54
channel, um, and let me know in the
11:56
comments your favorite markdown trick.
11:59
Thank you for watching and I will see
12:01
you in the next video.
Fixing merge conflicts with Codex
Sponsored
chatgpt.com
Sign up


