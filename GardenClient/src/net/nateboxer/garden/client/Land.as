package net.nateboxer.garden.client {
public class Land {
public static const LAND_STEP:int = 25;
public static const GROUND:Array = [
20,20,20,20,21,20,21,20,21,21,21,21,21,21,21,22,22,21,21,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,22,22,22,22,21,22,21,21,21,20,20,20,20,20,21,21,21,20,20,21,21,21,21,21,22,22,23,24,24,24,24,24,24,23,23,23,23,24,24,24,24,24,24,24,24,24,24
,23,23,24,24,24,24,24,24,24,24,24,25,25,26,26,26,25,24,25,25,25,26,26,26,26,25,25,25,26,25,26,26,27,26,26,25,24,24,24,24,25,25,25,25,26,25,25,26,26,26,26,26,25,24,24,24,25,26,26,26,27,26,26,26,25,25,24,24,24,24,25,24,24,24,24,23,23,23,23,22,21,20,20,20,20,20,21,21,21,21,21,21,21,22,22,22,22,21,20,21
,21,22,22,22,21,20,20,20,20,21,20,21,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,21,20,21,21,21,21,21,20,20,20,20,21,21,21,22,23,23,23,23,23,23,22,23,23,23,24,24,24,24,23,23,23,23,22,21,21,21,21,21,22,21,21,22,22,22,23,22,21,22,22,22,21,21,21,20,20,20,20,20,20,20,20,20,20,21,21
,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,21,21,22,22,22,21,21,21,22,22,21,21,22,22,22,22,22,23,24,23,24,23,23,23,24,25,24,24,23,23,23,23,22,22,22,22,22,21,21,22,22,22,22,22,21,21,20,20,21,21,21,21,20,20,20,21,20,20,20,20,20,21,21,21,22,23,23,22,22,22,22,23,23,23,23,24,23,23,23,23,22,21,21,21
,21,22,22,21,21,22,22,22,22,23,22,21,20,21,22,23,23,24,25,25,25,25,25,25,26,26,26,27,26,26,26,26,26,26,26,27,28,28,28,28,27,28,28,29,29,28,29,29,29,29,29,29,28,27,27,27,27,27,27,26,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,27,27,27,28,28,28,28,28,28,28,28,28,29,29,28,28,28,28,29,29,29,29,29,30,30
,30,30,31,31,32,32,32,33,33,33,33,33,34,34,35,35,35,34,34,34,34,34,33,33,33,32,32,31,31,30,30,30,30,31,31,32,32,32,33,33,33,34,35,35,35,36,36,36,36,36,36,37,37,37,37,37,38,38,38,38,39,40,40,39,38,37,37,36,35,35,35,35,34,34,34,34,35,34,33,33,32,32,32,33,33,33,33,33,33,33,32,31,30,30,30,30,30,30,30,31
,32,32,32,32,31,30,29,30,30,31,32,33,33,33,33,33,33,33,33,33,33,34,34,34,34,34,34,34,34,34,33,33,33,34,35,35,35,35,35,35,35,35,36,36,36,35,35,36,36,36,37,36,36,36,37,37,36,37,37,37,37,37,36,37,37,36,36,37,38,38,38,38,39,39,39,39,38,38,38,38,38,38,38,38,38,38,38,38,38,38,37,37,37,37,36,36,36,37,36,36
,35,35,36,37,37,38,39,39,39,40,40,40,40,39,39,39,40,39,39,39,40,40,40,40,39,38,38,38,38,38,37,37,38,38,37,37,37,36,36,36,35,35,35,35,35,35,35,35,35,35,35,36,35,34,34,34,35,35,34,34,34,34,34,34,34,35,36,36,36,36,36,37,37,37,37,37,37,38,38,38,37,38,38,39,39,39,40,40,40,40,39,38,38,38,38,38,38,38,38,38
,38,38,38,39,39,40,40,40,40,39,38,38,38,39,39,39,40,40,40,39,39,39,40,40,39,39,39,39,39,39,40,40,40,40,40,39,39,39,40,40,40,40,39,38,38,38,38,38,39,39,39,40,40,40,39,39,39,39,39,39,40,39,38,38,37,37,37,36,36,36,36,36,35,34,34,34,34,34,34,34,34,34,34,34,33,34,34,34,34,34,34,34,33,34,34,34,34,34,34,35
,35,35,35,35,35,35,35,35,34,34,34,33,33,33,33,32,32,32,32,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,33,34,34,34,34,35,35,36,37,37,37,37,38,38,37,36,36,36,35,35,36,36,36,35,35,34,34,33,34,34,35,35,35,35,35,35,35,35,35,36,36,36,36,36,36,36,35,35,35,35,34,34,35,35,35,35,35,35,36,36
,36,37,36,36,36,36,36,36,35,35,36,35,35,35,35,35,35,35,34,34,34,33,33,33,33,33,33,34,35,35,35,36,35,35,34,34,34,34,34,34,33,33,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,31,31,31,31,31,32,31,32,33,33,33,34,35,36,36,35,36,36,36,36,36,36,37,37,37,37,36,37,37,37,37,36,36,36,36,36,36,37,38,37,37,36,36
,36,36,36,36,37,37,37,37,37,37,37,37,37,37,38,38,37,37,37,37,37,36,36,36,36,35,36,36,36,36,37,36,35,35,36,36,36,36,36,35,34,34,34,34,33,33,33,34,33,33,34,34,34,35,35,35,34,35,36,36,36,37,37,37,36,36,36,35,35,35,35,35,36,36,37,37,36,36,35,36,36,37,38,38,38,38,38,38,38,39,40,40,40,39,39,38,39,38,38,37
,37,37,37,36,36,36,36,37,37,37,37,37,37,37,36,36,37,37,37,38,38,38,38,37,38,38,38,38,38,39,39,39,40,40,40,40,40,40,40,40,40,39,39,39,40,40,40,40,39,39,39,40,40,40,39,39,39,40,40,40,40,40,40,39,40,40,40,40,39,39,38,38,39,39,38,39,39,39,40,40,39,39,39,39,39,40,40,40,40,40,40,40,40,40,40,39,38,37,37,37
,37,38,37,37,37,38,39,39,39,39,39,39,39,39,39,39,39,39,40,40,40,39,39,39,40,39,39,39,39,38,37,37,37,37,37,37,38,37,36,35,35,36,36,35,35,35,35,36,36,35,35,34,34,34,34,34,34,35,34,33,32,32,32,33,33,34,34,34,34,34,34,34,34,34,33,33,33,32,32,32,32,33,32,32,32,32,32,32,32,32,32,32,32,32,31,30,30,30,30,29
,28,28,28,29,29,29,29,28,28,28,28,29,29,29,29,29,29,29,28,29,29,29,29,29,29,29,28,28,28,28,28,28,28,28,28,28,29,29,29,28,28,28,28,28,28,29,29,29,29,30,30,30,30,30,30,31,32,33,33,33,33,33,33,33,33,33,33,33,33,33,33,32,33,33,34,34,34,33,32,32,32,32,31,31,31,32,32,32,32,32,33,34,34,33,33,32,33,33,33,33
,33,32,32,32,33,33,32,32,32,32,32,32,32,33,33,33,32,32,32,32,31,30,30,31,31,31,31,31,31,31,30,30,31,31,32,33,33,33,32,31,30,31,31,32,32,32,32,32,32,32,32,32,32,32,32,31,31,31,31,30,30,30,29,30,30,31,31,30,30,30,30,30,31,31,31,31,32,33,33,34,34,34,34,34,34,33,33,34,35,35,35,34,34,33,33,33,34,34,34,34
,34,33,33,33,32,31,32,32,32,32,32,33,33,32,32,32,32,32,32,32,32,31,31,30,30,30,30,29,28,29,29,29,28,27,27,27,27,28,28,28,28,28,27,27,27,27,27,26,27,27,26,26,26,27,28,29,30,30,31,31,31,31,31,31,31,31,31,31,31,31,32,32,32,32,32,32,32,32,31,32,32,32,32,32,32,33,33,34,34,35,35,35,35,35,34,34,34,34,34,34
,33,34,33,33,32,32,32,32,32,32,33,33,33,33,33,32,31,31,31,31,31,31,30,30,30,30,30,30,30,29,29,30,29,29,29,28,28,28,29,28,27,27,28,28,29,29,29,29,29,30,30,29,29,29,29,29,30,30,30,30,31,30,30,30,30,30,29,29,29,29,29,29,30,31,31,30,31,31,31,32,32,32,32,32,32,32,32,32,32,32,32,31,31,31,31,32,33,33,33,33
,32,33,33,33,32,33,34,35,35,36,36,36,35,35,35,36,36,36,36,36,35,35,36,36,36,36,36,36,36,36,35,35,35,35,34,34,33,33,33,32,32,31,31,31,31,31,30,29,29,29,29,29,29,30,30,30,30,30,31,31,31,31,32,31,30,30,31,32,32,32,33,33,33,33,32,32,32,32,32,32,32,32,32,32,32,32,32,31,31,31,31,31,31,31,31,31,31,30,31,31
,32,33,33,33,33,33,33,33,33,33,32,32,32,32,31,31,31,32,32,32,32,32,32,32,32,32,32,31,31,31,30,30,30,30,30,30,31,31,31,32,32,31,31,31,32,32,32,31,31,32,32,32,32,31,31,32,32,32,32,32,32,31,31,30,29,29,29,28,28,28,29,29,29,29,29,29,29,29,29,30,31,31,31,31,31,31,31,30,30,30,30,31,31,31,31,31,32,32,32,33
,33,32,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,32,33,34,34,34,34,34,33,33,33,33,32,32,32,32,33,33,34,34,33,33,33,34,34,34,33,33,34,35,35,36,36,37,36,36,36,36,37,37,36,36,37,37,37,37,37,36,36,36,36,36,35,35,34,35,36,37,37,37,37,37,37,37,36,36,37,37,37,37,37,37,37,37,38,39,39,39,40,40,40,39,39
,39,39,39,39,38,38,38,37,36,36,36,36,36,36,36,36,35,35,35,36,35,35,36,36,36,37,36,36,35,36,36,36,36,36,36,37,36,36,36,36,37,37,37,37,38,38,37,38,39,39,40,40,40,40,40,39,39,40,40,40,40,40,39,39,39,39,38,39,39,39,39,39,39,39,40,40,39,38,38,38,38,38,38,38,38,37,37,37,37,37,37,38,38,38,37,37,37,37,37,37
,36,35,35,35,35,35,35,34,34,34,34,33,34,34,34,34,34,33,34,34,33,33,34,34,34,33,33,33,33,33,33,33,33,34,33,33,33,33,33,33,34,34,34,35,35,35,35,35,35,35,36,36,36,35,35,35,36,36,36,36,36,37,37,37,37,38,38,38,37,37,36,35,35,36,36,36,36,36,36,36,37,36,36,36,36,36,36,36,36,35,35,36,36,35,35,35,34,34,33,33
,33,33,32,33,33,33,34,34,34,35,35,35,35,36,35,35,36,36,35,35,36,35,34,35,35,34,34,34,34,34,34,33,33,33,32,33,34,33,33,33,34,34,34,34,35,35,34,33,32,32,32,33,33,33,32,32,31,31,32,32,33,33,33,34,34,35,35,35,34,35,35,36,36,36,36,36,36,35,36,37,37,37,37,37,37,37,38,38,38,39,39,38,39,39,39,39,39,38,37,38
,39,39,40,39,39,38,38,38,38,38,38,37,36,37,37,37,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,35,36,36,36,37,36,36,36,35,35,34,35,36,37,38,38,38,38,37,36,36,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,38,38,38,37,37,37,37,37,37,37,37,37,37,37,37,38,37,37,37,37,37,36,35,35,34,34,33,33,33,33,33,32
,31,31,31,31,31,31,31,30,31,31,30,30,31,30,30,29,30,31,30,30,29,28,29,29,29,29,30,29,29,29,29,29,28,28,28,29,30,29,29,29,30,31,31,31,31,31,31,31,32,32,33,34,34,34,33,33,33,33,32,32,32,31,32,32,32,32,33,33,34,35,35,35,35,34,34,34,33,34,34,35,35,35,35,35,35,35,35,34,34,35,34,34,34,33,33,33,33,33,33,33
,33,33,33,34,34,34,35,35,35,35,35,36,37,37,38,38,38,37,38,38,38,38,38,38,37,37,37,37,37,37,37,37,38,39,39,39,39,39,38,38,38,37,38,37,36,36,36,36,35,35,35,35,35,36,36,37,37,38,38,38,38,38,38,39,39,40,40,40,39,38,38,37,36,36,36,35,35,35,35,36,35,36,35,34,34,33,32,32,32,32,32,32,33,33,33,33,33,32,32,32
,32,31,30,30,30,31,30,30,30,30,30,30,30,29,28,27,27,27,28,28,27,27,28,28,28,27,26,26,26,26,26,25,26,26,26,26,25,25,25,25,26,26,26,26,26,26,25,25,26,26,26,25,26,26,26,27,26,26,27,26,26,25,25,24,24,24,24,24,24,24,23,23,23,22,22,22,22,21,22,21,21,22,22,22,22,23,24,24,23,23,23,24,23,23,23,24,25,25,26,26
,26,26,26,26,26,26,26,25,24,24,24,24,24,24,25,25,25,24,24,25,25,25,26,27,27,27,27,27,27,26,26,25,26,26,27,27,27,27,27,27,28,27,26,26,26,26,25,26,26,27,28,28,28,28,28,28,27,27,27,26,25,26,26,26,25,25,25,25,25,24,24,23,22,22,22,21,21,20,20,20,20,20,20,20,21,22,22,23,23,24,25,24,23,22,21,21,21,21,22,21
,21,21,21,22,22,22,23,22,22,22,22,21,21,21,22,21,20,20,20,20,20,21,21,21,21,21,20,20,21,20,21,21,21,21,20,20,20,20,20,21,21,21,22,22,22,23,23,23,22,21,21,21,22,22,22,21,21,21,20,20,20,20,20,20,21,21,21,21,21,21,20,20,21,21,21,21,20,20,21,21,22,22,22,23,23,23,24,24,24,24,25,24,24,23,22,22,22,22,21,21
,22,22,21,21,21,20,20,20,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,20,21,21,21,21,20,20,21,21,21,21,22,21,21,21,21,21,21,21,21,21,22,21,20,20,20,20,20,20,20,20,20,20,20,21,21,22,22,21,21,22,21,21,21,20,20,20,21,21,20,20,21,21,20,20,21,21,20,21,20,20,21,21,21,21,21,21,21,22,22,22,23,22,22,22,22,22
,22,22,22,23,22,22,22,22,23,23,23,23,23,23,22,22,22,22,23,22,22,23,23,23,24,24,24,24,24,24,25,25,25,25,25,25,24,24,23,23,23,23,23,23,24,23,23,23,23,23,23,22,22,22,22,22,21,21,21,21,21,22,22,22,22,21,22,23,23,23,23,23,22,22,23,23,22,22,21,20,20,20,20,20,21,22,22,22,22,22,22,21,20,20,20,20,20,20,21,21
,21,21,22,22,22,22,22,21,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,20,20,20,20,20,21,21,21,20,20,21,21,20,21,21,21,21,21,22,22,22,21,21,20,20,20,20,20,20,20,21,22,21,21,21,21,21,22,22,21,20,21,21,21,21,21,21,21,20,20,20,20,21,22,22,23,23,23,23,23,23,22,22,23,22,22,23,23,23,22,22,22,23,23,22,23
,22,23,23,23,24,24,25,24,23,22,22,22,22,23,23,24,24,24,23,22,21,21,21,21,22,22,22,22,22,21,21,20,20,20,20,20,20,20,20,21,21,22,22,21,22,22,22,22,22,22,22,23,24,24,24,23,23,22,22,22,22,22,21,21,21,20,20,20,20,20,20,20,20,20,21,22,22,21,21,20,20,21,20,20,20,21,20,20,20,20,20,20,20,20,21,20,20,20,21,21
,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,22,22,21,20,20,20,20,20,20,21,21,21,21,22,22,22,22,21,21,21,22,22,22,21,21,21,21,21,21,21,21,21,21,21,22,22,21,21,21,22,22,21,21,22,22,22,22,23,23,22,22,22,22,22,22,22,21,20,20,21,21,22,22,21,21,22,22,23,23,23,23,23,23,23,22,22,22,22,21,22,23,23,22,22,21
,22,22,22,23,23,23,23,22,22,21,21,21,21,21,21,20,20,21,21,21,21,21,21,21,21,21,21,21,21,21,21,20,20,20,20,20,21,21,21,22,22,22,22,22,22,22,22,22,22,21,21,22,22,22,22,22,21,21,22,22,22,22,22,22,22,22,21,20,20,20,21,21,21,20,20,20,21,21,22,22,22,21,21,21,22,22,23,24,24,24,24,25,25,25,26,26,27,27,27,27
,27,27,27,27,27,27,27,28,27,27,27,28,28,28,28,28,28,27,27,28,28,28,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,29,29,29,29,29,29,30,30,29,29,28,28,28,27,27,28,28,28,28,27,27,27,27,27,27,27,26,26,26,26,26,26,27,27,27,27,27,26,27,26,26,27,28,28,28,28,28,29,28,27,27,27,27,27,27,28,27,28,28,27,28,28
,28,28,29,30,30,30,30,31,31,30,31,30,31,31,31,31,31,30,30,30,30,30,29,29,29,29,29,29,29,29,29,29,29,29,30,30,29,29,28,28,28,27,27,26,26,25,25,25,25,26,25,25,24,23,23,23,23,22,22,22,22,23,24,24,24,25,25,25,25,25,25,26,27,26,25,25,25,25,25,25,26,26,26,25,25,24,24,24,24,25,25,25,25,25,25,25,24,24,24,24
,24,24,25,25,25,24,25,25,24,24,23,23,23,23,23,23,23,22,21,21,21,21,21,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,22,23,23,23,24,24,24,23,23,23,22,22,23,23,23,23,23,23,22,22,22,22,21,21,22,22,23,23,23,22,23,24,25,25,26,26,25,24,24,23,23,23,23,24,24,24,24,25,26,25,26,25,24,24,25,24,24,25,25,25,25,25
,25,24,24,24,24,23,23,23,23,23,23,23,23,22,22,21,21,21,21,21,21,21,21,22,21,20,21,21,20,20,20,20,20,20,20,21,21,21,21,22,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,23,24,24,24,24,23,23,24,24,24,23,23,23,22,22,22,22,22,22,21,21,21,21,22,21,21,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20
];
public static const HILLS:Array = [
41,41,41,41,41,40,40,40,40,42,42,42,44,41,41,41,41,41,41,40,40,40,42,43,43,43,43,43,43,43,43,40,40,40,40,40,40,40,40,40,42,40,40,41,41,41,45,47,44,44,44,44,44,44,44,46,46,44,44,44,44,44,43,41,42,42,41,45,48,49,47,51,47,47,44,44,44,42,46,42,42,40,40,43,46,45,45,45,45,45,45,46,46,46,49,49,49,49,49,49
,46,46,46,42,44,42,40,42,42,42,42,42,42,42,42,42,46,47,47,51,51,51,51,51,53,51,52,52,52,52,52,52,52,52,52,52,48,44,45,46,46,46,46,46,49,47,45,45,45,45,48,48,51,51,51,47,44,47,50,50,48,51,53,53,52,51,51,51,51,51,51,51,55,58,58,58,58,58,55,55,55,59,59,59,59,61,61,61,65,65,61,57,57,54,57,53,53,51,50,53
,56,60,60,60,61,65,65,66,66,69,69,69,69,69,69,71,71,71,71,71,70,70,69,69,69,67,67,67,67,70,68,68,72,72,72,69,69,69,68,64,64,68,70,70,70,68,72,75,74,74,78,77,77,77,77,77,75,75,75,76,76,76,78,77,77,77,75,75,75,74,70,71,71,67,67,67,66,66,63,63,59,57,60,59,63,63,63,63,59,59,56,59,59,58,58,57,57,57,56,58
,62,62,58,58,59,58,58,55,55,58,58,58,57,57,58,58,58,58,58,58,61,61,61,65,63,63,63,63,66,70,73,73,73,76,76,72,70,70,70,70,70,71,71,71,71,67,67,65,61,61,61,59,61,61,64,64,64,64,64,61,61,61,61,61,58,54,50,50,52,50,50,50,51,51,54,56,56,60,56,59,59,59,59,63,63,66,68,68,68,64,64,61,61,62,62,62,65,65,65,62
,58,58,62,62,60,60,60,57,57,57,53,52,52,52,52,52,55,55,57,57,59,63,63,63,63,64,63,67,68,68,68,68,68,68,68,70,72,72,72,72,70,70,68,68,70,72,72,72,70,66,70,66,66,67,70,69,70,70,70,74,74,74,73,73,74,74,73,73,75,75,79,83,83,82,82,79,82,82,82,83,84,84,84,80,80,80,79,79,82,82,82,84,84,88,88,88,92,92,90,90
,90,87,87,86,86,82,81,84,80,76,76,76,72,73,74,74,74,74,73,72,72,72,76,72,75,75,75,76,74,76,79,79,79,79,75,75,71,71,71,68,68,72,76,76,76,76,78,76,72,72,70,66,64,62,62,63,64,62,62,62,62,62,62,60,63,60,60,56,56,56,56,53,50,50,50,47,48,52,50,52,53,53,53,53,53,53,53,52,48,48,50,51,51,51,51,51,53,53,55,59
,55,53,53,53,53,57,56,56,56,58,58,56,58,58,55,51,55,58,60,60,60,60,60,60,60,60,60,60,60,61,61,60,60,60,60,64,64,64,62,63,63,67,70,70,70,70,70,69,69,66,68,68,68,68,65,67,67,67,67,71,69,66,69,69,67,68,68,66,70,70,67,67,69,71,71,71,71,70,70,70,74,78,77,77,81,81,81,83,83,87,88,88,86,82,82,82,78,78,78,78
,78,78,81,81,81,82,79,80,80,80,78,78,78,77,77,75,75,75,75,75,75,75,79,79,79,77,77,77,75,75,75,75,75,75,75,79,79,79,83,83,83,86,87,88,88,84,80,77,75,75,78,75,75,77,79,81,81,78,80,82,82,80,80,83,83,86,86,86,83,83,85,89,89,89,86,86,86,86,86,86,87,86,83,80,84,84,84,82,78,78,78,82,82,82,82,82,82,82,80,80
,80,76,76,77,77,77,77,81,81,85,85,82,79,79,76,74,74,74,74,71,74,74,77,77,77,74,74,74,76,74,72,69,69,69,72,70,68,68,70,74,74,74,70,67,71,71,71,67,67,69,65,65,61,60,60,63,63,63,66,65,64,64,64,64,63,63,64,61,62,66,66,66,66,64,60,60,60,60,59,56,58,56,56,56,54,50,50,50,54,52,52,48,44,45,45,45,44,44,44,48
,48,48,48,48,46,46,43,43,42,42,42,42,42,42,42,40,43,43,45,45,45,43,45,45,45,41,41,40,40,40,40,40,40,40,40,40,40,40,40,44,44,40,40,43,43,43,42,42,46,47,45,45,42,40,40,40,43,40,40,40,43,43,42,42,42,42,42,42,42,45,45,45,42,42,40,44,40,40,40,40,43,44,44,44,47,47,49,49,50,50,54,54,54,54,56,56,56,56,55,58
,54,51,53,53,53,55,52,52,52,52,53,53,53,51,52,52,48,47,45,47,47,48,48,48,48,48,48,48,48,48,48,48,50,50,50,50,50,50,50,46,46,48,44,48,48,48,46,44,44,44,47,51,49,49,49,49,45,46,46,45,45,41,40,40,44,44,40,40,40,40,40,40,40,40,40,40,40,40,40,43,43,43,43,40,40,40,40,40,40,40,40,40,40,44,41,44,45,45,42,40
,40,40,40,40,40,41,41,43,42,42,46,46,49,51,51,54,50,52,52,56,60,60,57,58,58,57,60,58,58,58,56,59,59,59,58,58,60,61,59,62,62,62,62,62,62,66,66,66,66,66,69,69,69,69,69,69,69,71,71,73,73,73,73,72,75,71,71,71,71,71,71,71,72,74,74,71,71,67,67,65,64,61,64,64,64,63,66,70,70,73,76,75,75,77,77,75,73,71,71,71
,71,71,74,74,71,71,67,67,67,67,67,67,66,66,64,64,64,64,64,64,62,58,58,58,60,60,60,56,56,59,59,59,59,59,59,59,59,61,61,58,57,55,51,51,51,51,51,51,51,51,51,48,48,48,50,50,50,50,47,47,47,47,47,47,51,51,50,50,50,50,52,52,52,55,58,58,58,61,57,57,57,53,53,53,49,49,46,46,46,46,46,46,49,52,53,51,51,49,52,56
,52,49,49,49,49,49,46,46,45,45,49,49,51,51,51,51,54,54,55,56,56,56,59,59,63,64,64,63,63,63,63,61,59,59,59,59,59,62,61,61,63,63,63,62,62,66,66,66,66,66,63,63,63,63,66,66,67,67,66,66,65,65,67,67,67,67,67,67,67,67,64,65,65,65,65,67,65,65,67,68,68,68,64,63,63,64,64,65,61,61,61,62,60,60,60,63,63,60,62,64
,66,66,69,69,66,69,69,69,69,69,67,67,67,65,65,65,65,65,61,61,63,63,60,60,63,63,63,63,63,61,61,61,58,59,59,55,55,51,51,55,56,60,60,60,60,59,59,58,58,58,61,60,60,60,61,61,61,63,63,63,67,67,66,65,65,64,64,62,63,63,59,59,61,57,57,58,58,62,62,62,62,66,67,67,67,67,67,71,68,66,70,74,73,73,69,69,69,71,71,71
,70,67,67,67,67,67,64,64,61,61,57,56,56,56,59,59,56,56,57,55,56,53,53,51,51,51,51,47,49,45,47,48,48,48,48,48,49,45,47,47,47,50,50,50,47,45,43,42,45,45,45,45,42,42,42,42,42,40,40,40,40,40,40,44,41,41,41,41,40,40,40,40,41,43,41,42,42,40,42,42,42,42,42,43,43,41,40,40,40,40,40,40,40,41,41,43,46,46,49,49
,49,45,45,45,45,45,43,43,40,40,40,40,40,40,40,40,44,44,42,45,43,43,43,43,43,40,40,40,40,40,40,42,42,42,40,40,40,40,40,40,40,40,40,40,40,40,40,44,44,44,44,44,44,45,47,47,47,47,48,51,52,52,55,55,52,51,53,49,51,51,53,53,53,53,53,53,53,53,50,53,56,56,56,56,59,59,59,59,59,59,55,55,59,59,62,59,59,59,59,60
,60,60,61,58,58,56,56,54,54,54,54,50,48,48,47,47,45,45,45,45,45,45,45,44,44,44,44,47,47,43,43,45,45,45,45,45,43,45,45,45,42,42,43,43,40,40,40,40,40,40,40,43,40,40,42,42,40,40,40,42,42,42,42,42,45,42,42,44,44,43,47,47,44,46,50,48,44,46,43,43,45,45,45,45,43,45,45,42,42,42,42,41,41,41,43,47,48,48,47,47
,47,47,45,42,46,50,50,48,48,50,50,50,52,52,52,53,49,49,46,43,43,40,40,40,40,44,44,44,47,47,46,46,42,42,42,42,42,43,43,44,44,44,44,44,44,44,44,45,45,44,42,42,41,42,46,49,49,48,48,48,51,51,53,52,52,49,49,50,50,51,50,50,50,50,51,52,54,54,54,58,58,58,58,58,58,58,58,58,58,58,58,54,54,54,56,58,61,61,61,61
,62,64,64,64,64,65,65,65,65,67,67,67,67,67,66,66,70,70,68,71,71,74,74,74,74,74,74,77,77,77,81,81,81,80,80,80,80,80,84,81,81,81,83,82,82,82,82,82,83,83,83,83,79,79,79,79,82,82,78,78,82,82,82,82,82,82,82,79,75,75,75,72,72,74,73,73,75,74,71,72,72,72,72,72,72,71,74,74,74,74,74,78,78,78,78,78,78,78,80,79
,81,79,81,82,78,75,77,77,78,78,75,74,74,72,72,68,68,68,68,66,66,66,69,65,65,65,65,63,63,63,65,64,62,62,62,60,59,59,62,66,66,66,66,66,66,64,63,63,63,59,61,61,57,61,61,58,58,55,55,57,57,61,61,61,58,58,58,58,58,58,58,57,57,57,57,57,55,55,55,55,55,57,57,58,58,57,57,57,57,58,54,54,54,52,52,51,48,51,48,48
,48,48,48,48,48,48,48,48,48,48,47,43,43,43,43,43,41,41,41,41,43,45,42,42,42,42,43,43,43,40,42,42,41,42,42,42,42,42,41,41,41,41,40,43,47,47,47,47,51,49,49,49,46,49,49,49,49,49,52,51,53,55,55,55,59,59,59,59,59,59,62,62,64,64,68,65,61,63,63,60,60,62,65,61,61,58,58,58,58,61,61,61,62,62,62,62,62,64,64,60
,60,60,60,61,61,58,58,58,54,58,59,62,59,62,62,61,64,67,67,63,62,66,66,66,64,68,69,69,65,65,65,65,68,68,65,63,61,64,64,66,66,70,70,70,70,72,72,74,74,77,77,77,77,78,79,78,78,78,74,74,74,74,78,76,76,76,76,73,76,76,76,76,76,76,77,77,77,77,79,77,77,81,83,80,79,77,74,73,73,69,69,69,69,69,66,67,67,65,65,64
,66,70,70,70,70,66,66,70,70,74,78,78,80,84,84,84,84,84,85,85,85,85,85,89,87,90,93,93,93,93,93,97,99,99,98,99,102,102,102,102,102,99,101,103,103,103,104,104,105,108,104,104,102,102,98,98,97,97,97,101,104,100,100,100,102,102,100,100,99,99,99,103,100,98,102,102,102,102,106,106,106,110,110,110,110,110,113,116,117,117,117,119,119,119,119,115,115,115,115,115
,115,115,115,115,115,116,120,121,125,125,123,123,123,124,124,124,120,120,121,121,121,121,121,120,120,119,119,119,119,117,117,113,113,113,113,111,111,108,108,108,107,103,103,103,103,102,102,106,106,106,108,112,111,111,111,108,108,112,113,113,111,114,113,109,109,109,108,108,108,112,112,112,113,113,113,113,113,109,109,109,113,117,121,121,121,121,120,120,116,117,113,110,110,114,114,117,117,119,117,117
,118,118,121,121,125,125,125,126,126,126,126,126,127,127,127,127,123,120,117,113,116,116,115,115,115,115,115,115,115,115,115,115,111,114,110,108,105,105,105,105,103,103,103,103,102,105,101,101,104,104,104,104,104,104,102,103,102,102,102,105,105,105,108,110,109,108,108,108,110,110,112,112,112,108,108,108,104,108,108,108,111,113,113,113,113,113,115,111,111,110,110,112,112,115,115,115,115,118,117,117
,117,117,117,117,117,117,117,117,113,110,110,110,111,110,111,111,111,111,111,107,107,111,111,111,111,111,111,111,109,109,111,113,113,115,115,119,115,114,113,116,112,112,110,112,112,111,111,111,111,111,111,111,115,113,113,111,112,111,111,111,108,108,108,108,108,108,110,110,110,110,110,111,111,107,104,107,103,103,103,105,103,103,103,102,102,102,102,104,106,106,106,106,105,104,104,101,98,98,100,100
,96,99,99,96,96,96,96,96,96,93,93,93,92,94,95,94,95,99,99,99,100,100,103,103,103,103,106,106,106,106,106,108,108,105,105,102,102,103,103,102,102,102,105,105,105,102,104,105,108,108,106,104,104,107,107,107,109,109,110,110,109,109,109,111,111,111,113,113,113,113,117,117,117,117,113,116,114,110,110,106,106,107,107,107,107,106,106,104,102,102,102,102,102,102,102,105,102,105,105,105
,105,105,109,109,110,110,110,110,106,108,104,104,104,104,100,100,100,100,97,94,97,97,97,97,98,100,101,101,101,101,101,101,102,102,102,103,103,103,103,103,103,99,95,98,100,100,100,100,100,97,93,93,89,89,92,92,95,95,95,95,95,95,95,95,99,99,99,99,102,98,98,97,97,93,93,93,94,96,96,97,99,99,99,99,97,98,94,94,94,96,100,97,98,98,98,98,98,98,98,100
,100,98,98,102,105,105,105,105,105,109,109,105,105,105,101,100,97,97,98,95,93,97,99,102,102,102,102,100,100,100,100,100,100,100,96,96,93,93,93,93,97,100,100,100,97,94,93,95,97,97,93,93,93,90,87,87,87,87,87,87,87,87,87,88,88,85,85,85,85,85,85,87,89,88,91,91,94,92,91,94,94,94,90,90,91,95,97,94,94,95,95,93,94,94,94,94,93,93,93,91
,91,91,91,94,93,93,89,90,94,94,94,94,92,95,95,95,95,93,95,95,95,95,99,99,100,96,96,98,98,94,94,94,91,95,99,98,98,98,101,102,102,105,106,106,105,105,105,108,108,108,108,112,110,110,113,113,116,116,116,112,115,111,107,107,107,110,110,110,108,109,109,111,113,111,111,111,111,111,111,111,111,111,111,111,111,112,112,112,112,114,114,114,114,115,115,115,118,118,118,120
,120,120,123,123,123,123,123,123,123,122,122,122,126,126,126,126,128,128,128,128,131,131,131,131,130,130,130,126,126,126,129,129,125,125,125,125,121,121,121,118,116,116,116,116,120,118,121,121,122,122,122,122,122,122,119,119,119,119,119,115,115,115,115,116,116,118,120,123,126,126,126,128,128,128,128,128,128,128,127,127,127,127,127,127,127,127,127,123,127,127,127,127,127,127,128,129,129,126,124,124
,124,121,118,115,115,118,117,117,114,112,111,112,112,112,112,112,112,112,114,114,116,116,118,115,113,113,110,110,110,109,109,109,109,108,108,108,106,108,112,115,114,114,114,114,111,111,110,107,110,110,110,110,110,110,108,108,107,106,110,110,110,110,111,111,109,109,105,105,103,102,99,99,102,99,99,99,99,99,100,100,100,100,96,96,100,104,105,105,105,101,101,103,103,101,105,101,99,99,99,99
,103,103,103,103,107,103,101,102,102,99,98,101,105,109,109,109,107,109,109,109,107,109,109,106,109,109,109,113,109,112,112,114,111,111,111,113,117,117,117,117,118,118,117,117,117,117,116,116,117,117,118,118,121,121,121,121,122,120,117,117,116,116,116,116,119,123,124,123,126,123,123,123,123,127,127,127,124,124,127,127,131,131,130,130,130,130,128,130,130,130,130,130,130,131,131,131,129,131,135,133
,133,133,130,132,132,132,132,132,132,130,130,130,132,134,134,134,133,137,137,137,137,137,137,133,134,134,134,132,131,129,128,128,131,133,136,136,136,134,134,134,131,127,127,130,130,132,132,132,129,129,126,124,127,130,130,132,131,131,131,131,131,132,132,132,130,130,130,130,130,130,128,128,128,128,131,131,128,128,128,125,125,125,125,129,133,136,136,136,136,136,133,133,129,129,129,130,130,134,134,135
,139,141,145,145,145,148,146,142,141,141,141,141,141,137,137,133,133,130,130,127,127,125,126,126,126,126,126,130,126,126,123,123,126,126,124,123,123,125,126,129,130,132,132,132,128,128,128,128,128,128,128,126,126,128,128,126,126,126,126,126,126,129,129,128,128,131,131,134,134,135,135,135,135,135,135,135,135,135,135,136,132,130,132,136,136,140,140,140,140,143,140,139,139,140,136,138,134,134,134,134
,137,137,140,138,138,135,131,131,133,133,133,133,133,133,134,134,134,134,134,134,132,132,132,135,135,135,138,138,138,138,141,141,140,136,135,135,136,136,136,136,136,136,135,132,132,132,132,132,132,131,131,132,132,132,132,134,135,135,136,136,136,138,136,136,136,135,135,132,133,133,130,130,130,130,130,132,135,135,135,135,135,135,135,133,132,132,128,127,127,127,127,129,129,127,124,124,122,122,122,122
,122,126,126,122,122,119,116,116,116,120,120,120,120,119,118,118,116,118,122,122,124,126,126,126,128,127,127,127,127,123,123,123,127,128,130,130,130,134,134,135,135,135,135,136,136,136,133,134,134,134,134,131,131,131,131,131,128,128,125,127,127,127,126,126,126,126,126,126,126,125,129,129,129,130,130,130,130,134,136,133,133,133,133,133,130,130,130,130,127,127,124,127,127,131,131,131,131,132,132,129
,130,130,133,133,133,135,135,135,138,138,139,139,139,141,141,141,141,141,143,146,146,146,146,146,148,148,148,146,149,149,147,147,147,150,150,150,150,150,150,150,154,153,156,156,155,157,157,159,159,162,162,162,158,156,156,156,156,156,155,156,156,156,156,156,157,157,159,159,159,159,155,155,155,152,149,151,150,150,151,151,147,150,150,152,152,152,152,152,152,156,156,156,160,164,164,164,164,166,166,165
,165,162,160,156,152,154,153,153,153,153,153,153,152,156,156,156,156,155,154,155,155,155,153,155,156,158,155,155,155,155,155,157,160,163,160,162,162,162,162,164,166,164,162,159,157,155,152,151,149,147,145,143,140,136,134,129,123,122,120,114,111,110,108,108,106,103,101,96,94,91,89,88,86,82,80,78,76,70,68,66,65,61,56,54,54,53,51,45,41,40,40,40,40,40,40,40,40,40,41,40
];
public function Land() {}
}
}
