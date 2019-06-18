(define (domain mbt3)
 (:requirements :strips :typing :equality :fluents :adl)
 (:types active address server status-si status-lo status-se type expect result username password button action method integer sqli xssi response script sql_mutation xss_mutation mutcount old_sql_mut old_xss_mut freev value - object)
(:constants init - active no yes - status-lo two - status-si sqli rxss sxss - type get post head - method username - username password - password)
 (:predicates
 			(inInitial ?x)
 			(inAddressed ?x)
 			(inSentReq ?x)
 			(inRecReq ?x)
 			(inSQLI ?x)
 			(inRXSS ?x)
 			(inSXSS ?x)
 			(inParse ?x)
 			(inRecognize ?x)
 			(inAttackedSQL ?x)
 			(inAttackedRXSS ?x)
 			(inAttackedSXSS ?x)
 			(inRecResp ?x)
 			(inRecRespChoose ?x)
 			(inRecRespRXSS ?x)
 			(inFound ?x)
 			(inFinal ?x)
 			(inGenerate ?x)
 			(inGenerateXSS ?x)
 			(inRevisitedSXSS ?x)
 			(inCMSQL ?x)
 			(inCMXSS ?x)
 			(Logged ?lo)
 			(statusinit ?si)
 			(Type ?type)
 			(Server ?sr)
 			(Empty ?url)
 			(Response ?resp)
 			(SQLI ?sqli)
 			(XSSI ?xssi)
 			(Username ?un)
 			(Password ?pw)
 			(GivenSQL ?sqli)
 			(GivenXSS ?xssi)
 			(Method ?m)
 			(Found ?exp - expect ?resp - response)
 			(FoundScript ?script - script ?resp - response)
 			;(MutateSQL ?sqli ?mutcount)
 			(MutateSQL ?sqli)
 			(MutateXSS ?xssi ?mutcount)
 			;(MutSQLmapWhite ?sqli - sqli ?mutop - sql_mutation)
 			;(MutSQLequal ?sqli - sqli ?mutop - sql_mutation)
 			;(ExhaustedSQLI ?sqli - sqli ?mutop - sql_mutation ?m - method)
 			;(Next ?mutop - sql_mutation)
 			(SubmitSQL ?sqli - sqli ?exp - expect ?m - method ?un - username ?pw - password)
 			(SubmitXSS ?xssi - xssi ?m - method ?un - username ?pw - password))
 
 (:functions 
 			(statusinit ?si - status-si)
 			(Method ?m - method)
 			(Logged ?lo - status-lo)
 			;(logged ?lo - status-lo)
 			(sent ?se - status-se)
 			(Type ?type - type)
 			;(httpm ?m - method)
 			(UsedM ?um - integer)
 			;(UsedMut ?umt - integer)
 			(SQLMut ?mutcount - mutcount)
 			(XSSMut ?mutcount - mutcount)
 			(OldMutOp ?osm - old_sql_mut)
 			(OldMutXss ?oxm - old_xss_mut)
 			(Flag ?m - method ?value - value)
 			(username ?un - username)
 			;(Counter ?counter - counter)
 			(password ?pw - password) )
 			;(Successful ?result - result)
 
 (:action Start 
 			:parameters(?x - active ?url - address ?lo - status-lo)
 			:precondition (and (inInitial ?x) (not (Empty ?url)) )
 			;precondition (and (inInitial ?x) (not (Empty ?url)) (not (inInitial init)))  
 			:effect (and (inAddressed ?x) (not (inInitial ?x)) (Logged yes) ))
 
 (:action SendReq
 			:parameters(?x - active ?lo - status-lo ?se - status-se ?si - status-si)
 			:precondition (and (inAddressed ?x) (Logged yes) )
 			:effect (and (inSentReq ?x) (not (inAddressed ?x)) (assign (sent ?se) 1) (statusinit two)))
 
 (:action RecReq
 			:parameters (?x - active ?si - status-si)
 			:precondition (and (inSentReq ?x) (statusinit two) )
 			:effect (and (inParse ?x) (not (inSentReq ?x)) ))
 			
 (:action NReq
 			:parameters (?x - active ?si - status-si ?lo - status-lo)
 			:precondition (and (inSentReq ?x) (not (statusinit two)) )
 			:effect (and (inInitial ?x) (not (inSentReq ?x)) (Logged no) ))
 			
 (:action Parse
 			:parameters(?x - active ?m - method ?un - username ?pw - password ?type - type)
 			:precondition (and (inParse ?x) (=?un username) (=?pw password) (or (Method get)(Method post)(Method head)) ) 	
 			;effect (inFound ?x))
 			:effect (and (not (inParse ?x)) (inRecognize ?x) ))
 			;else: when Type sql (inSQL) when Type rxss ...
 			
 (:action ChooseSQLI
 			:parameters(?x - active ?type - type)
 			:precondition (and (inRecognize ?x) (Type sqli) ) 	
 			:effect (and (not (inRecognize ?x)) (inSQLI ?x) ))
 
 (:action ChooseRXSS
 			:parameters(?x - active ?type - type)
 			:precondition (and (inRecognize ?x) (Type rxss) ) 	
 			:effect (and (not (inRecognize ?x)) (inRXSS ?x) ))
 
 (:action ChooseSXSS
 			:parameters(?x - active ?type - type)
 			:precondition (and (inRecognize ?x) (Type sxss) ) 	
 			:effect (and (not (inRecognize ?x)) (inSXSS ?x) ))
 
  (:action GenerateSQLI
 			:parameters(?x - active ?sqli - sqli)
 			:precondition (inGenerate ?x) 	
 			:effect (and (not (inGenerate ?x)) (inSQLI ?x) (MutateSQL ?sqli) ))
 
 (:action AttackSQLI
 			:parameters (?x - active ?sqli - sqli ?m - method ?un - username ?pw - password ?exp - expect)
 			:precondition (and (inSQLI ?x) (GivenSQL ?sqli) )
 			:effect (and (SubmitSQL ?sqli ?exp ?m ?un ?pw) (inAttackedSQL ?x) (not (inSQLI ?x))))

 (:action ReceiveResp
 			:parameters (?x ?resp)
 			:precondition (and (inAttackedSQL ?x) (Response ?resp))
 			:effect (and (inRecResp ?x) (not(inAttackedSQL ?x))))
 
 (:action ParseRespSQL
 			:parameters (?x - active ?exp - expect ?resp - response)
 			:precondition (inRecResp ?x)  
 			:effect (and (inRecRespChoose ?x) (not(inRecResp ?x))) )
 			;effect (inFound ?x))
 			;effect (and (when (Found ?exp ?resp) (and (inFound ?x)(not(inRecResp ?x))) ) (when (not(Found ?exp ?resp))(and (inGenerate ?x) (not(inRecResp ?x)) ))))
 			
 (:action ParseRespSQLFinish
 			:parameters (?x - active ?exp - expect ?resp - response)
 			:precondition (and (inRecRespChoose ?x) (Found ?exp ?resp) )  
 			:effect (and (inFound ?x)(not(inRecRespChoose ?x))) )
 
 (:action ParseRespSQLCheck
 			:parameters (?x - active ?exp - expect ?resp - response)
 			:precondition (and (inRecRespChoose ?x) (not(Found ?exp ?resp)) )  
 			;effect (and (inGenerate ?x) (not(inRecRespChoose ?x))) )			
 			:effect (and (inFound ?x) (not(inRecRespChoose ?x))) )
 			
(:action AttackRXSS
 			:parameters (?x - active ?xssi - xssi ?m - method ?un - username ?pw - password)
 			:precondition (and (inRXSS ?x) (GivenXSS ?xssi))
 			:effect (and (SubmitXSS ?xssi ?m ?un ?pw) (inAttackedRXSS ?x) (not (inRXSS ?x))))
 
 (:action AttackSXSS
 			:parameters (?x - active ?xssi - xssi ?m - method ?un - username ?pw - password)
 			:precondition (and (inSXSS ?x) (GivenXSS ?xssi))
 			:effect (and (SubmitXSS ?xssi ?m ?un ?pw) (inAttackedSXSS ?x) (not (inSXSS ?x))))
 			
 (:action ParseRespXSS
 			:parameters (?x - active ?script - script ?resp - response)
 			:precondition (or (inAttackedRXSS ?x) (inAttackedSXSS ?x)(inRevisitedSXSS ?x))  
 			:effect (and (inRecRespRXSS ?x) (not(inAttackedRXSS ?x))) )
 			;effect (and (FoundScript ?script ?resp)(inFound ?x)(not(inAttackedRXSS ?x))))
 
 
 
 (:action ParseRespXSSCheck
 			:parameters (?x - active ?script - script ?resp - response)
 			:precondition (and (inRecRespRXSS ?x) (not(FoundScript ?script ?resp)) )  
 			;effect (and (inGenerate ?x) (not(inRecRespChoose ?x))) )			
 			:effect (and (FoundScript ?script ?resp)(inFound ?x) (not(inRecRespRXSS ?x))) )
 
 (:action Finish
 			:parameters (?x)
 			:precondition (inFound ?x)
 			:effect (inFinal ?x))
 )