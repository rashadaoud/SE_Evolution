module metrics::SigModelScale
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
import Map;

public list[str] sigScales = ["++", "+", "o", "-", "--"]; 
public map[str, int] sigScalesMap = ("++":1,"+r":2,"o":3,"-":4,"--":5);
public map[str, int] distribution = ("Moderate":1,"High":2,"VeryHigh":3);