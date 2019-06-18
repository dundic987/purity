(define (problem mbt3-problem)
 (:domain mbt3)
 (:objects 
 		x - active
 		s - server
 		si - status-si
 		lo - status-lo
 		se - status-se
 		type - type
 		url - address
 		fv - freev
 		m - method
 		a - action
 		exp - expect
 		b - button
 		un - username
 		pw - password
 		result - result
 		sqli - sqli
 		xssi - xssi
 		script - script
 		resp - response
 		;counter - counter
 		;mutop mapW mapEq urlE highC insCom addS escK - sql_mutation
 		mutop - sql_mutation
 		mutxss - xss_mutation
 		mutcount - mutcount
 		osm - old_sql_mut
 		oxm - old_xss_mut
 		um - integer
 		value - value
 		)
 		
 (:init
 		(inInitial x)
 		(Logged no)
 		(not (statusinit two))
 		(Type rxss)
 		;(Type sqli || rxss || sxss)
 		(= (sent se) 0)
 		;(= (httpm m) 0)
 		;(= (Counter counter) 0)
		(not (Empty url))
		(GivenSQL sqli)
		(GivenXSS xssi)
		(not (ExhaustedSQLI sqli mutop m))
		(= (UsedM um) 0)
		(= (SQLMut mutcount) 0)
		(= (XSSMut mutcount) 0)
		(Method get)
 		(= (OldMutOp osm) 0)
 		(= (OldMutXss oxm) 0)
 		(= (Flag post value) 0)
 		(= (Flag get value) 0)
 		(= (Flag head value) 0)
		(Response resp)
		(not (Found exp resp))
		(not (FoundScript script resp))
 		(Server s)
 )

 
 (:goal (inFinal x)))
