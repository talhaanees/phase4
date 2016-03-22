67272 Creamery Project: Phase 4 Starter
===

This is the starter code for Phase 4 of the [67-272 Creamery Project](http://67272.cmuis.net/projects).  This starter code includes the models previously given and the tests associated with them.  There are controllers (and tests) but no views since views are irrelevant this phase.

You will need to run `bundle install` to get the needed testing gems.  You can populate the development database with realistic data by first running `rake db:migrate` and then `rake dp:populate`. This will give you five stores with over 200 employees (some active, some inactive), each having one or more assignments.

As always, should you or any of your I.M. Force be caught or killed, the Secretary will disavow any knowledge of your actions.  This message will self-destruct in five seconds. Good luck.

This phase will take substantially longer than phase 2 and it is recommended that students start early.  Some models are also significantly easier / less demanding than others, so it might be a good idea to knock these simpler ones out of the park first before tackling the more challenging ones.

Finally, we do expect you to write a migration for adding the latitude and longitude fields to the stores table.  These fields were not part of phase 2 and need to be included here.
