## Chapter 21

## A Network Troubleshooting Methodology

This chapter covers the following topics related to Objective 5.1 (Explain the troubleshooting methodology) of the CompTIA Network+ N10-009 certification exam:

- Identify the problem

  - Gather information
  - Question users
  - Identify symptoms
  - Determine if anything has changed
  - Duplicate the problem, if possible
  - Approach multiple problems individually
- Establish a theory of probable cause

  - Question the obvious
  - Consider multiple approaches

    - Top-to-bottom/bottom-to-top OSI model
    - Divide and conquer
- Test the theory to determine the cause

  - If theory is confirmed, determine next steps to resolve problem
  - If theory is not confirmed, establish a new theory or escalate
- Establish a plan of action to resolve the problem and identify potential effects
- Implement the solution or escalate as necessary
- Verify full system functionality and implement preventive measures if applicable
- Document findings, actions, outcomes, and lessons learned throughout the process

As you perform your day-to-day tasks of administering a network, a significant percentage of your time will be dedicated to resolving network issues. Whether the issues you are troubleshooting were reported by an end user or were issues you discovered, you need an effective plan to respond to them. Specifically, you need a systematic approach to clearly articulate an issue, gather information about the issue, hypothesize the underlying cause of the issue, validate your hypothesis, create an action plan, implement that action plan, observe results, and document your resolution. Without a plan, your efforts might be inefficient, as you try one thing after another, possibly causing other issues in the process.

Although your troubleshooting efforts can most definitely benefit from a structured approach, realize that troubleshooting is part art and part science. Specifically, your intuition and instincts play a huge role in isolating an issue. Of course, those skills are developed over time and come with experience and exposure to more and more scenarios.

To help you start developing or continue honing your troubleshooting skills, this chapter presents a troubleshooting methodology that can act as a guide for addressing almost any network issue. This chapter also presents a collection of common network issues to consider in your real-world troubleshooting efforts (and issues to consider as you prepare for the CompTIA Network+ exam).

### Foundation Topics

### Troubleshooting Basics

Troubleshooting network issues is implicit in the responsibilities of a network administrator. Such issues could arise as a result of human error (for example, a misconfiguration), equipment failure, software bugs, or traffic patterns (for example, high utilization or a network being under attack by malicious traffic).

Many network issues can be successfully resolved using a variety of approaches. This section begins by introducing you to troubleshooting fundamentals and then presents a structured troubleshooting methodology you should know for the Network+ exam.

#### Troubleshooting Fundamentals

The process of troubleshooting, at its essence, is the process of responding to a problem report (sometimes in the form of a *trouble ticket*), diagnosing the underlying cause of the problem, and resolving the problem. Although you normally think of the troubleshooting process beginning when a user reports an issue, through effective network monitoring, you might detect a situation that could become a troubleshooting issue and resolve that situation before it impacts users.

After an issue is reported, the first step toward resolution is clearly defining the issue. After you have a clearly defined the troubleshooting target, you can begin gathering information related to that issue. Based on the information collected, you might be able to better define the issue. Then you can hypothesize the likely causes of the issue. Evaluation of these likely causes leads to the identification of the suspected underlying root cause of an issue.

After a suspected underlying cause is identified, you define approaches to resolve an issue and select what you consider to be the best approach. Sometimes the best approach to resolving an issue cannot be implemented immediately. For example, a piece of equipment might need to be replaced. However, implementing such an approach during working hours might disrupt a business’s workflow. In such situations, a troubleshooter might use a temporary fix until a permanent fix can be put in place.

As a personal example, when helping troubleshoot a connectivity issue for a resort hotel at a major theme park, my coworkers and I discovered that a modular Ethernet switch had an issue causing Spanning Tree Protocol (STP) to fail, resulting in a Layer 2 loop. This loop flooded the network with traffic, preventing the hotel from issuing keycards for guest rooms. The underlying cause was clear: The Ethernet switch had a bad module. However, the issue was pinpointed around 4 p.m., a peak time for guest registration. So, instead of immediately replacing the faulty module, we disconnected one of the redundant links, thus breaking the Layer 2 loop. The logic was that it was better to have the network function at this time without STP than for the network to experience an even longer outage while the bad module was replaced. Late that night, someone came back to the switch and swapped out the module, resolving the underlying cause while minimizing user impact.

[Figure 21-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#ch21fig01) provides a simplified model of the troubleshooting steps just described, which consists of three steps:

**Step 1.** Problem report

**Step 2.** Problem diagnosis

**Step 3.** Problem resolution

![](../images/21fig01.jpg)


**Figure 21-1** Simplified Troubleshooting Flow


![](../images/key_topic_icon_158.jpg)

Of these three steps, the majority of a troubleshooter’s efforts are spent in the *problem diagnosis* step. [Table 21-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#ch21tab1) describes key components of this diagnosis step.

![](../images/key_topic_icon_158.jpg)


**Table 21-1** Steps to Diagnose a Problem

| Step | Description |
| --- | --- |
| Gather information. | Because a typical problem report lacks sufficient information to give a troubleshooter insight into a problem’s underlying cause, the troubleshooter should collect additional information, perhaps using network maintenance tools or interviewing impacted users. |
| Duplicate the problem, if possible. | Testing to see if you can duplicate the problem is often a key step in problem diagnosis. |
| Question users. | Although it can be difficult to gather information from your end users, doing so is often critical in correctly pinpointing the exact problem. Oftentimes, finding out user actions prior to the problem is critical. |
| Identify symptoms. | What symptoms has the problem has created? |
| Determine if anything has changed. | Perhaps your end users will provide valuable clues if they accurately indicate what changes they might have made to systems. |
| Approach multiple problems individually. | Unfortunately, you might discover that there are multiple issues. Be sure to approach each one individually. |

#### Structured Troubleshooting Methodology

Troubleshooting skills vary from administrator to administrator. Therefore, although most troubleshooting approaches include the collection and analysis of information, elimination of potential causes, hypothesis of likely causes, and testing of the suspected cause, different troubleshooters might spend different amounts of time performing these tasks.

If a troubleshooter does not follow a structured approach, the temptation is to move between the previously listed troubleshooting tasks in a fairly random way, often based on instinct. Although such an approach might well lead to problem resolution, it can become confusing to remember what you have tried and what you have not tried. Also, if another administrator comes to assist you, communicating to that other administrator the steps you have already gone through could be challenging. Therefore, following a structured troubleshooting approach not only helps prevent you from trying the same thing more than once and inadvertently skipping a task but also aids in communicating to someone else the possibilities you have already eliminated.

You might encounter a variety of structured troubleshooting methodologies in networking literature. However, for the Network+ exam, the methodology shown in [Figure 21-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#ch21fig02) is the one you should memorize.

![](../images/21fig02.jpg)


**Figure 21-2** Structured Troubleshooting Approach


![](../images/key_topic_icon_158.jpg)

The following is an elaboration on this seven-step methodology:

**Step 1.** **Identify the problem.** Effective troubleshooting begins with a clear problem definition. This definition might include specific symptoms. Here’s an example: “User A’s computer is unable to communicate with server 1 (as verified by a ping test). However, user A can communicate with all other servers. Also, no other user seems to have an issue connecting to server 1.” This problem definition might come from questioning the impacted user(s) and doing your own testing (for example, seeing if you can ping from user A’s computer to server 1). If possible, determine whether anything has changed in the network (or in the computer) configuration. Also, find out whether this is a new installation that has failed to work in the past.

![](../images/key_topic_icon_158.jpg)

**Step 2.** **Establish a theory of probable cause.** This is the point in the troubleshooting process where your experience and intuition can be extremely helpful because it is when you brainstorm a list of possible causes. As you brainstorm, be sure to question the obvious. Also, think in terms of [***top-to-bottom troubleshooting***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_705) (moving from top to bottom within the OSI model) or [***bottom-to-top troubleshooting***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_099). Alternatively, you could use a [***divide-and-conquer troubleshooting***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_220) approach. When examining your collected data (for example, output from the **ipconfig/all** command), question everything. For example, you might think that the issue described in step 1 could result from causes such as an ACL blocking traffic to or from the PC, a connectivity issue with the PC or server, or an incorrect IP address configuration on the PC. From your list of possible causes, select the one you consider the most likely. From the previous list, you might believe that an incorrect IP address configuration on the PC is the most likely cause of the problem. Specifically, you might conclude that the issue is not related to connectivity because other PCs can get to the server, and user A’s PC can get to other servers. Also, you might conclude that it is more likely that user A’s PC has a bad IP address configuration than that an ACL has been administratively added to the router to block traffic only between user A’s PC and server 1.

**Step 3.** **Test the theory to determine the cause.** Before taking action on what you consider to be the most likely cause of a problem, do a *sanity check* on your theory. Would your hypothesized cause lead to the observed symptoms? In the example presented in the preceding steps, you might examine the subnet mask assigned to user A’s computer and determine that it is incorrect. Specifically, the subnet mask makes user A’s computer think that server 1 is on the same subnet as user A’s computer. As a result, user A’s computer does not forward traffic to its default gateway when attempting to reach server 1. If your hypothesis is technically sound, you can proceed to step 4. However, if you notice a flaw in your logic, you need to formulate an alternate hypothesis. The formation of an alternate hypothesis might involve escalating the problem to someone more familiar with the device(s) in question.

**Step 4.** **Establish a plan of action to resolve the problem and identify potential effects.** Once you have confirmed that your theory makes sense technically, you need to develop an action plan. If time permits, you should document your action plan. The documentation of your action plan can be used as a *back-out plan* if your hypothesis is incorrect. In the example we have been building on throughout these steps, an action plan might be to change the subnet mask on user A’s computer from 255.255.0.0 to 255.255.255.0.

**Step 5.** **Implement the solution or escalate as necessary.** Based on your documented plan of action, you should schedule an appropriate time to implement the action plan. The selection of an appropriate time is a balance between the severity of a problem and the impact your action plan will have on other users. Sometimes, when attempting to implement an action plan, you realize that you do not have sufficient administrative privileges to perform a task in your action plan. In such cases, you should escalate the issue to someone who has appropriate administrative rights. In this example, changing the subnet mask on one computer should not impact any other devices. So, you might immediately make the configuration change on user A’s computer.

**Step 6.** **Verify full system functionality and implement preventive measures if applicable.** After implementing an action plan, you need to verify that the symptoms listed in your original problem definition are gone. You also need to attempt to determine whether your action plan has caused any other issues on the network. A mistake many troubleshooters make at this point is believing that the issue has been resolved because the specific symptom (or symptoms) they were looking for is gone. However, the user who originally reported the issue might still be having a problem. Therefore, troubleshooters should live by the mantra “A problem isn’t fixed until the user believes it’s fixed.” You should get confirmation from the person reporting an issue that, from her perspective, the reported issue has indeed been resolved. In this example, you could attempt to ping server 1 from user A. If the ping is successful, you can check with user A to see whether she agrees that the problem is resolved.

**Step 7.** **Document findings, actions, outcomes, and lessons learned throughout the process.** Notice how this step really emphasizes documentation. That’s right—you should be documenting throughout the entire process. This often includes the creation of a postmortem report. A *postmortem* report is a document that describes the reported issue, its underlying causes, and what was done to resolve the issue. This report might be useful when troubleshooting similar issues in the future.

Keep in mind when working your way through the previous steps that you might encounter an issue that you do not have sufficient information to solve. When that happens, you might need to further research the issue yourself. However, if time is of the essence, you might need to immediately escalate the issue to someone else within your organization, to an equipment vendor, or to an outside consultant.

### Real-World Case Study

The Acme, Inc. networking team and some key IT stakeholders are analyzing the efficiency of the support desk. During this analysis, it was discovered that the previous attempts at an enforcement of a troubleshooting methodology were not being followed. The methodology also had several weaknesses to it that did not warrant following to begin with. Finally, it was discovered that the documentation of the desired troubleshooting methodology was sorely lacking.

The networking team is now implementing training on a new and improved troubleshooting methodology and is introducing several new software tools that will make it easier to follow and more effective overall. This new troubleshooting approach begins with a careful identification of the problem and establishment of a theory of probable cause. The process then involves the following steps: testing the theory to determine the cause; establishing a plan of action to resolve the problem; implementing the solution; verifying full system functionality; and finally, ensuring documentation has been created or updated throughout the process.

### Summary

Here are the main topics covered in this chapter:

- This chapter covered the basics of troubleshooting and looked at the fundamentals of this vast subject.
- This chapter described a structured troubleshooting methodology.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 21-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#ch21tab02) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 21-2** Key Topics for [Chapter 21](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#ch21)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| [Figure 21-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#ch21fig01) | Simplified Troubleshooting Flow | 491 |
| [Table 21-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#ch21tab1) | Steps to Diagnose a Problem | 491 |
| [Figure 21-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#ch21fig02) | Structured Troubleshooting Approach | 492 |
| Step list | Steps in the CompTIA Network+ structured troubleshooting methodology | 493 |

### Complete Tables and Lists from Memory

Print a copy of [Appendix B](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appb.xhtml#appb), “[Memory Tables](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appb.xhtml#appb),” or at least the section for this chapter, and complete as many of the tables as possible from memory. [Appendix C](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc), “[Memory Tables Answer Key](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc),” includes the completed tables and lists so you can check your work.

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[bottom-to-top troubleshooting](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#key_01)

[divide-and-conquer troubleshooting](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#key_02)

[top-to-bottom troubleshooting](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#key_03)

### Additional Resource

**Use a Troubleshooting Methodology for More Efficient IT Support:** <https://www.comptia.org/blog/troubleshooting-methodology>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz21_1) Which of the following is often the first step in a structured troubleshooting methodology?

1. Test possible causes.
2. Create an action plan.
3. Establish a theory of probable cause.
4. Identify the problem.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz21_2) Which of the following comprise a simplified troubleshooting flow? (Choose three.)

1. Problem resolution
2. Problem monitoring
3. Problem diagnosis
4. Problem report

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz21_3) What step is most likely to follow the “establish a plan of action” step in a structured troubleshooting methodology?

1. Implement the solution.
2. Test the hypothesis.
3. Define the problem.
4. Hypothesize the possible cause.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz21_4) Which networking troubleshooting methodology step would include establishing a new theory or escalating if the theory is not confirmed?

1. Step 1: Identify the problem.
2. Step 4: Establish a plan of action to resolve the problem and identify potential effects.
3. Step 2: Establish a theory of probable cause.
4. Step 3: Test the theory to determine the cause.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz21_5) You have verified full system functionality and implemented preventive measures. What should you do next?

1. Question the obvious and duplicate the problem.
2. Create a differential backup plan.
3. Document findings, actions, outcomes, and lessons learned.
4. Gather information and create a baseline.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz21_6) In the networking troubleshooting methodology, which of the following are included in Step 2, “Establish a theory of probable cause”? (Choose two.)

1. Top-to-bottom/bottom-to-top OSI model
2. Divide and conquer
3. If theory is confirmed, determine next steps to resolve problem
4. If theory is not confirmed, establish a new theory or escalate