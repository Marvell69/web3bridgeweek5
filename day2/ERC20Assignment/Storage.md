# Assignment

## Where are your structs, mappings and arrays stored.

When you define define structs,
In Solidity, structs, mappings, and arrays when declared as state variables in a contract are all stored in the contract’s persistent storage

## How they behave when executed or called.

Structs

In storage: changing fields updates the persistent state of the contract.

In memory: they are just temporary copies changes aren’t saved after the function ends.

Arrays

Storage arrays: keep all elements between calls; changes inside a function persist.

Memory arrays: exist only in that function call and disappear afterward.

Mappings

Always stored in storage you can’t have a mapping in memory.

When you set or get values in a mapping inside a function, you’re accessing the stored data directly.

## Why don't you need to specify memory or storage with mappings

You don’t specify memory or storage for mappings because Solidity only allows mappings to be stored in storage.
It doesn’t have a predictable sequence of elements like an array, so Solidity doesn’t know how to place it in memory.
