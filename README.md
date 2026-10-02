# redot-reuse-addr-port-demo

Test client for testing [this redot pull request](https://github.com/Redot-Engine/redot-engine/pull/1464).


## Usage

Run at least 3 instances of the program.
- One instance with `--server` argument to create a server that will broadcast udp packet with 
specific payload on port 6769.
- At least 2 instances without any extra arguments, they will both attempt to bind to port 6769.


## Results of the test

If server window says "Actively yelling into the void" and BOTH client windows say "I heard a server!",
the test is successful and 2 or more clients bound the 6769 port.


## Sanity checks

If the test is successful, failure path also should be tested. Add `--disablereuse` argument to all
the clients. This should cause only one client to display "I heard a server!" and rest should
display "My ears are closed!". This will make sure that the feature only works when explicitly set.
