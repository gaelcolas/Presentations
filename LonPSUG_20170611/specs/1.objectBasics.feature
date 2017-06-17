@ObjectBasics
Feature: Discover the basics of PowerShell objects
    This first objective for us is to recap the basics about Objects in PowerShell
    We'll talk:
    WMI, PowerShell, .Net and others
    Objects: Class, Type, Instance, $Null
    Objects' members: Property, Method
    modifiers: Static, Public, Private, Hidden

    @PS
    Scenario: Have a look at the objects in PowerShell
        Given we have CIM and WMI Objects
        And we have Net objects
        And we have other type of objects

    @OOP
    Scenario: Make the naming and concepts clearer
        Given we have Classes in CS or PS
        And objects are instantiations of Class
        And we have Type and Type Accelerators

    @members
    Scenario: Look at Object members through the PS lens
        Given an instance of an object
        And its different members
        And You can create your own object in PS
