# GovernmentID

## Project Idea

Inspired by the AdNovum challenge, we decided to create a blockchain to show the use-cases for governments to fight against fraudulent identification papers and to show visas could be handled also on the blockchain.

## Infrastructure

This software is built using a Multichain deployed on multiple Ubuntu EC2 AWS instances. ExpressJS was used to create the API and a server is deployed on every node. Finally, we developed a front-end application in Swift the accessibility of the project.

## Git Release Flow

To push some new commits :

- `git checkout -b branch-name master`
- Code
- `git add .`
- `git commit -m "message"`
- `git fetch`
- `git rebase origin master`
- Resolve eventual conflicts
- `git push origin branch-name`
- Create MR

## AWS Instance

Connection to the AWS instances were described in the `parameters.txt` file, removed here because not accessible anymore. The private blockchain key was also removed for obvious reasons.

## Created by

Kilian D'Eternod, Eloi Garandel and Antoine Bellanger in 2019.
