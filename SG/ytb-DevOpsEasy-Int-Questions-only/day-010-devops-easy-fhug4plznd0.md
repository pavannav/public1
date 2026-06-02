<details open>
<summary><b>Day 010 - DevOps Easy Interview (KK-CS45-script-v2-Interview)</b></summary>

# Extracted Interview Questions

1. Can you please introduce yourself?

2. Can you explain what is Docker and how does it differ from a virtual machine?

3. Can you show me the architecture of virtual machine and Docker container by sharing your screen? I want to see the difference how the application will be deployed in the virtual machine and how the application will be deployed in a container.

4. Do you know what is hypervisor? What is the use of that hypervisor?

5. If hypervisor is a OS then what is the Guest OS then?

6. What is the kernel? Can you able to tell me what is kernel?

7. How does Docker handle networking and what are the different network types?

8. After container engine, there is a container runtime, then containers are there right? How are you handling multiple containers? Are you manually spinning up every container? How will you manage all the containers?

9. Are you familiar with Docker compose?

10. Can you explain the docker compose lifecycle?

11. How are you managing your Dockerfile? Are you manually writing or can we generate it?

12. Will you able to explain few of the docker commands which you have worked on?

13. What is the use of the volume here? What is Docker volume?

14. What different types of volume are there? Named volume and Bind mounting, what is the difference between these two?

15. Can you tell me the difference between CMD and ENTRYPOINT?

16. What is the default entry point if you are not mentioning any entry point?

17. What's the difference between entry point and CMD?

18. Normally when you take any Docker images from Docker Hub, what does the image contain? Does it contain your application code or your application will be sitting somewhere and it will connect to that?

19. How will you pass environment variables to your Docker container?

20. How are you sending logs to your Docker container? Where are those logs going?

21. If you want to store all the logs somewhere, how will you store them?

22. How will you take a backup of those logs? Will you able to store the logs inside the container?

23. If application is crashing, will data be lost or not?

24. How are you restarting your containers when it gets stopped? Are you restarting manually or how are you restarting?

25. What are the restart policies available?

26. Normally if your container is not coming up, if it's keep on restarting, how will you check the logs?

27. Can you come to Docker networks? How many network types are there?

28. What is bridge network?

29. Is bridge network the default network when you spin up a container?

30. How will you attach a custom bridge network to your container?

31. What is the difference between default bridge network and custom bridge network?

32. What is host network?

33. How are you communicating between two different containers using custom bridge network? Will you able to communicate between each other?

34. What is overlay network?

35. What is the use case of overlay network?

36. Can you tell me the difference between all the network types in Docker? Bridge, host, overlay, and none?

37. When you run Docker ps, what are all the things it will show?

38. How will you check the status of the container? How many types of status are there?

39. When you are saying the container is running, is it healthy or unhealthy? How will you check?

40. If you want to check the health of a container, what will you do? What is the command to check health check?

41. With this health check, how are you monitoring your containers? Where are you getting the notification?

42. How will you differentiate between running, healthy, and unhealthy containers when you run docker ps?

43. When you see a container status as restarting, how many times it has restarted?

44. How will you stop this container from restarting?

45. What is Docker compose?

46. How does Docker compose work?

47. If you have three services in docker compose, how are they communicating with each other?

48. How will you differentiate between docker compose up and docker compose start?

49. If your container is stopped, will docker compose up start it?

50. What are the different options available in Docker compose? Can you tell me some commands?

51. If you want to scale up your containers using Docker compose, how will you do that?

52. If you're running multiple images of the same container, how will you differentiate each one? How are you differentiating each one of those containers?

53. How will you monitor multiple containers which are running? How will you differentiate each container?

54. What are the different container tools you have worked on? Docker and any other tools?

55. Have you heard about podman?

56. How are you accessing your containers? Are containers accessible from outside?

57. How does your container communicate with outside applications?

58. How are you exposing your container ports?

59. If you want to connect your services with each other without exposing any port, how will you do that?

60. When you're saying connect to other service, who are other services?

61. Is this service running inside the same docker compose file or running in a different virtual machine?

62. What is the Docker socket file? Can you explain the use cases of Docker socket file?

63. Is the Docker socket file present inside the container or outside the container?

64. Have you heard about DinD concept? Docker in Docker?

65. Have you used Docker socket file anywhere in your organization for any of the use cases?

66. Why do we need Docker socket file? What's the use of the socket file?

67. How does Docker handle data persistence?

68. Can you tell me use cases where we need Docker volume?

69. What are the different types of volumes available?

70. What is the difference between bind mount and named volume?

71. When you want to store your logs, which type of volume will you use?

72. Can you please explain the difference between anonymous volume, named volume, and bind mount?

73. How will you take a backup of the Docker volume? If you have sensitive files in the Docker volume, how will you take a back up?

74. What is Docker secret?

75. How will you pass Docker secrets to your container?

76. What different commands have you used in Docker? Can you tell me few commands which you remember?

77. What are the fields available in the Dockerfile?

78. When you are giving a FROM instruction, what command are you giving after FROM instruction? Why are you giving WORKDIR?

79. What's the purpose of giving EXPOSE?

80. Have you used multi-stage build?

81. What is the use of multi-stage build?

82. Can you able to tell me some of the best practices of Dockerfile?

83. How are you scanning your Docker images? Have you heard about Trivy?

84. How are you scanning the image while building?

85. Have you created any Jenkins pipeline to scan the image?

86. Do you know any other tools to scan the Docker images?

87. When you are working with Docker, what different kinds of errors you have faced?

88. What is the file called where you define your Docker compose configuration?

89. Can you explain the docker compose lifecycle?

90. Have you heard about docker compose convert command?

91. After convert, does it give any file or where does it give the output?

92. Have you used --dry-run option?

93. Can you tell me few of the best practices of Docker compose?

94. How are you handling Docker networks in Docker compose? Are you using default bridge network or are you using custom networks?

95. How are you connecting one container with another container? How are you able to connect using service name?

96. How are you managing multiple Docker compose files? Are you using a single docker-compose.yml or using multiple?

97. Is there any override file you are using? What is the use of override file?

98. If your production environment and development environment having different configurations, how will you handle that with Docker compose?

99. How will you pass environment variables while doing docker compose up?

100. Have you worked on any Docker swarm concepts?

101. Have you heard about the orchestrator tools available in the Docker?

102. What's the use of Docker context? Have you used Docker context anywhere?

103. If you have three different environments, how can you switch between those environments using Docker context?

104. Have you heard about Docker registry concept?

105. How are you pushing your Docker images? Where are you pushing?

106. Have you used Docker hub?

107. Have you used any private registry? Like ECR, ACR, GCR?

108. How are you authenticating to your Docker registry before pushing?

</details>