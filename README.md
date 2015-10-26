#Introduction Report
##Glance

###Code architecture

![alt text](schema2.jpeg)

(Glance registry is an optional layer organizing secure communication between the database abstraction layer and and the controller.)

###References to `sqlalchemy`

The references to `sqlalchemy` can be found in `db.sqlalchemy.api`. As done in `Nova` project, we should copy/paste the code and edit it accordingly.

Here is the methodology used by Jonathan Pastor with Nova: 

- Copy/paste the `db.api.py` file
- Run the project
- Modify the code depending upon the errors raised
	- CURL requests to Nova API endpoints
	- Until all endpoints work with `ROME`

As suggested by Jonathan, we should use the same approach to update the references to `sqlalchemy` in Glance.

###Update `ROME` to add new DB queries
As `Nova` is bigger than `Glance`, it is possible that every DB queries needed by `Glance` are already implemented in `ROME`. However we will need to test every endpoint and add the missing queries if needed.


##Nova

###Changes made in `db.discovery.api` to use `ROME`
- get_session
	- returns a `RomeSession` instead of a standard `SQLAlchemy` session.

- model_query
	- returns `RomeQuery` instead of standard query.

- service_create
	- Uses a lock (DLM) to create the service in a distributed context. Releases the lock after creation.

	- Call `service_create_` to create the service.

- service\_create_
	- Replaces `nova.db.sqlalchemy.models.Service().update(values)` and uses instead `model_query` and key/value system.

- service_update
	- Checks that new values has key `report_count` and that `values.report_count == service_ref.report_count`, ???? otherwise doesn't update the service.
	- Adds `session.add(service_ref)`. ???

- compute\_node\_get_all
	- Uses `RomeQuery` to return all compute nodes in a key/value way.

- compute\_node_update
	- Adds `session.add(compute_ref)` "to ease the session management" ????

- floating\_ip_deallocate
	- Adds `session.add(result)` "to ease the session management" ????

- fixed\_ip\_associate, fixed\_ip\_associate_pool
	- Logs the info in the log file.    
Add a lock before the action and additionals checkings regarding generated `fixed_ip`.

- fixed\_ip\_disassociate\_all\_by\_timeout, fixed\_ip\_get\_by\_instance, fixed\_ip\_update, instance\_get\_all, instance\_get\_all\_by\_filters, network\_get\_associated\_fixed\_ips, block\_device\_mapping\_update\_or\_create, \_security\_group\_create, flavor\_get\_all, aggregate\_get\_by\_metadata\_key, aggregate\_update, aggregate\_metadata\_add, action\_event\_finish, instance\_group\_update, instance\_group\_update
	- Implements methods that used to be in `IMPL` class with a hard coded implementation.
