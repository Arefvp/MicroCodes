# MicroCodes
This repository includes the MATLAB codes used to create examples of MicroCodes as well as samples of navigation codes for the binary MicroCodes. Applications, fabricaiton, and use-cases are described in the following paper: [Paper link]
If you use the platform, please cite our paper and this GitHub repository.

This repository also includes fab-ready GDSII (.gds) files for fabricating MicroCodes and MicroCoded-Filters. The masks are designed such that they would work for both positive and negative photo resists and cover both top-down and bottom-up microfabrication approaches. In top-down microfabrication approaches, for negative photoresist, direclty expose the intended layer structure. To get the intended mask for positive photoresis (e.g. Microposit photoresist family), use the XOR [https://en.wikipedia.org/wiki/Exclusive_or] function on the first layer (the circle structure) and the intended layer. For bottom-up fabrication, reverse the instructions.
