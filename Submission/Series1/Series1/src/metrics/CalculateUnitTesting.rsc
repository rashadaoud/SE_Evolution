module metrics::CalculateUnitTesting
/**
 * Bonus
 * 
 * @author ighmelene.marlin, rasha.daoud
 *
 */
import IO;
import Set;
import List;
import Relation;
import util::Math;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::m3::AST;

import Extractor;
import metrics::SigModelScale;

/*
*	rank 	unit test coverage
*	############################
*	++ 			95-100%
*	+ 			80-95%
*	o 			60-80%
*	- 			20-60%
*	-- 			0-20%
*
*/

//list[loc] extractBaseTestClasses(M3 model) = [from | <from,to> <- model.extends, to == "TestCase"];

/* get all methods in test-units */
list[loc] extractTestsMethods(M3 model, loc extendedTestClass) {
	list[loc] junitClasses = 
		[from | <from,to> <- model.extends, to == extendedTestClass];   
   // println("<junitClasses>");
    return [m | c <- junitClasses, m <- methods(model, c)];
}


/* get methods that are called from test-units */
list[loc] extractCalledMethods(M3 model, loc extendedTestClass) {
	// grep all methods that are in a class  for testing (extends BasicTestCase)
    list[loc] ms = extractTestsMethods(model, extendedTestClass);
    list[loc] result = [];
    for (<caller, called> <- model.methodInvocation) {
    	if (caller in ms && called notin ms) {
    		result += called;
    	} else continue; 
    }
   return result;
}


/* calculate the unit-test-coverage, it is needed for test-quality */
public int getUnitTestCoverage(M3 model, loc extendedTestClass) {
	int methodsToTest = 
	 size([m | m <- methods(model), m notin extractTestsMethods(model, extendedTestClass)]);
	int calledMethods = size(extractCalledMethods(model, extendedTestClass));
	//println("<methodsToTest>, <calledMethods>");
	if (methodsToTest !=0) return percent(calledMethods,methodsToTest); else return 0;
}


/* get sig-model ranking for unit-test-coverage */
public int getUnitTestCoverageRanking(int ratio) {
	if(ratio >=95) return sigScales[0]; // ++
	if(ratio >=80)  return sigScales[1]; // +
	if(ratio >=60)  return sigScales[2]; // o
	if(ratio >=20)  return sigScales[3]; // -
	return sigScales[4]; // --
}


/* get assert count in test-units */
public int getCountAssertionStatements(M3 model, loc extendedTestClass) {
    int total = 0;
    list[loc] junitClasses = 
		[from | <from,to> <- model.extends, to == extendedTestClass];   
   
    for(c <- junitClasses){
    	counter 	= 0;
		a 	= getFileAst(c);
		for(f <- [d | /Declaration d := a, isMethod(d.decl)]){
			visit(f){
				case \method(_,_,_,_,Statement impl): {
					visit (impl){
						// assert, assertTrue, assertFalse, assertEquals ..etc..
			            case \assert(_): counter += 1;
			            case \assert(Expression expression, Expression message): counter += 1;
			            case \methodCall(bool isSuper, /^assert/, list[Expression] arguments): counter += 1;			 		
			        }
				};
			}
		}
		total += counter;
    }
    return total;
}