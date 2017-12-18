module metrics::CalculateVolume
/**
 *
 * This module is
 * 
 * @author ighmelene.marlin, rasha.daoud
 *
 */
import IO;
import String;
import List;
import util::Math;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::\syntax::Java15;
import Main;
import Extractor;
import metrics::SigModelScale;
import metrics::CalculateLOC;

/* Based on java KLOC ranking for Volume of a project, get the sig scale string
*	
*		Rank (Java KLOC)
*		##############
*		 ++   0-66
*		##############
*		 +   66-246
*		##############
*		 o   246-665
*		##############
*		 - 	 655-1,310
*		##############
*		 --	 > 310
*		##############
*
*	getVolumeAllFiles(smallModel);
*	int: 24048
*	getVolumeAllClasses(smallModel);
*	int: 23673
*/


/* calculate volume based on classes in java project - Halstead volume */
public int getVolumeAllClasses(M3 model) = (0 | it + countLOC(c) | c <- extractClasses(model)); //RD method

/* calculate volume based on files in java project */
public int getVolumeAllFiles(M3 model)   = (0 | it + countLOC(f) | f <- extractFiles(model)); // RD method

/* get sig ranking string based on volume */
public str getVolumeRanking(int vol) {
	if(vol <= 66000) return sigScales[0];
	if(vol <= 246000) return sigScales[1];
	if(vol <= 665000) return sigScales[2]; 
	if(vol <= 1310000) return sigScales[3];
	return sigScales[4];
}
