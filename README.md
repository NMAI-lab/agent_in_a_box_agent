# Agent in a Box
The Agent in a Box provides a framework for developing autonomous mobile robots using Beliefs-Desires-Intentions (BDI) and Jason (https://github.com/jason-lang/jason, http://jason.sourceforge.net/). It has been designed to work with ROS (https://www.ros.org/) using the savie_ros_bdi node (https://github.com/NMAI-lab/savi_ros_bdi) although it is also possible to use the behaviour framework without ROS.

This documnent provides a brief explanation of the Agent in a Box as well as how to use it. Additional documentation is available in published papers. There are also a number of demo projects that have used the Agent in a Box. These serve as good working examples of how to use the framework.

## Litterature
Gavigan, P.; Esfandiari, B. Agent in a Box: A Framework for Autonomous Mobile Robots with Beliefs, Desires, and Intentions. Electronics 2021, 10, 2136. https://doi.org/10.3390/electronics10172136

## Example Uses
The following are examples of this framework in use. These working examples show what domain specidic work is needed to run use this framework.

Grid Agent: https://github.com/NMAI-lab/jasonMobileAgent

Grid Agent with ROS: https://github.com/NMAI-lab/jason_mobile_agent_ros

AirSim Car: https://github.com/NMAI-lab/AirSimNavigatingCar

Mail Delivery using a Roomba: https://github.com/NMAI-lab/saviRoomba

## How to Use
There are two main components to the software in this repository. First is the berahviour framework itself, which provides generic code for controlling the robot. These plans require certain other plans to be provided to it for some of the lower level control of the robot. For example, the framework provides a `navigate` plan for generating a route to a destination and then moving the robot to the destination. This plan needs to be provided a set of plans for achieving the `waypoint` goal, which moves the robot between individual locations. The second component is the prioritization of the agent's behaviour. This was accomplished through modification of Jason's event and option selection functions to prioritize certain behaviours over others. Both of these components are further documented in the following sections.

### Behaviour Framework
The behaviour framework is shown in the following figure. It includes a number of plans and rules that provide useful features for controlling a mobile robot. These generic plans require several other plans to be provided in order to control the robot's domain specific actuators and sense the environment using the domain specific sensors.

The main plans that the agnet uses are detailed below. This also explains what is needed to be provided or what is expected.

- Navigation Mission
  - Top level goal/trigger: `!mission(navigate,[Destination])`.
  - A basic navigation mission is provided. This mission moves the robot to the requested named destination using the `!navigate(Destination) goal.
- Mission
  - Additional missions can be provided for the agent by providing additional plans that achieve the `!mission(Goal,ParameterList)` goal. By using this common mission level achievement goal, other plans in the framework can invoke this mission. This is especially important in the event that the mission is interrupted and needs to be resumed.
  - `Goal` is the achievmeent goal that implements the mission
  - `ParameterList` is a list of parameters that need to be passed to that mission as parameters.
- Navigate
  - Top level goal/trigger: `!navigate(Destination)`.
  - Navigates the robot to a destination. Requires a map (explained next). Uses A* search to generate a plan (the route) to the destination.
  - Required beliefs/ perceptions: `position(X,Y)`, which is the agents position on the map.
- Map
  - The map of the environment. This consists of a set of map beliefs and rules. This needs to be provided by the developer.
  - Location Names: A set of location names need to be provided in this format: `locationName(Name,[X,Y])`
  - Charging station location: The location of the charging station needs to be provided: `chargerLocation(Name)`
  - Possible map transitions: The locations that the agent can move to from any given location: `possible(StartingPosition, PossibleNewPosition)`
  - Successor state predicates: Used by the navigation search, these predicates define the state the robot will be in if it transitions from one location to another. This rule should yield a predicate of this form: `suc(CurrentState,NewState,Cost,Operation)`
  - Heuristic: Used by the navigation search to estimate the range (or other cost metric) to the destination for any position on the map. This rule should yield a predicate of this form: `h(Current,Goal,H)`.
- Movement
- Obstacle

- Map Update
- Resource Management
- Collision Avoidance

![Framework](https://github.com/NMAI-lab/agent_in_a_box_agent/blob/master/figures/AIB_Framework.png)

### Prioritization of Behaviour
![Prioritization](https://github.com/NMAI-lab/agent_in_a_box_agent/blob/master/figures/AgentInABoxBehaviourPrioritization.png)

