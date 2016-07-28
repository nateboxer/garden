<?php

require_once 'Seed.php';

class Evolver 
{
    
    public function __construct() 
    {
 		$db = mysql_connect( "xxx", "xxx", "xxx" );
		if( $db ) 
		{
			if( !mysql_select_db( "garden", $db ) ) 
			{
				echo 'error selecting db';
			}
		} 
		else 
		{
			echo 'mysql connect error';
		}
	}
	
	public function updateSeed( $id, $name )
	{
		$query = "update seed_bank set name = '$name' where id = $id";
		if( $result = mysql_query( $query ) )
		{
			return "<success>$query</success>";
		}
		else
		{
			return "<error>$query</error>";
		}
	}
	
	public function saveSeed( $genes, $parent_id, $name, $user_ip, $generation ) 
	{
		
		// insert into seed_bank
    	$query = 'insert into seed_bank'
    		. ' ( genes, parent_id, name, user_ip, generation ) '
    		. " values ( '$genes', $parent_id, '$name', '$user_ip', '$generation' ) ";
		$result = mysql_query( $query );
		
		$new_id = mysql_insert_id();
		
		// update parent, if any
		$query = "select id from seed_bank where id = $parent_id";
		if( $result = mysql_query( $query ) )
		{
			if( mysql_num_rows( $result ) > 0 )
			{
				$query = "update seed_bank set children = (children + 1) where id = $parent_id";
				mysql_query( $query );
			}
		}
		
		return $new_id;
	}
	
	public function getRandomSeed()
	{
		$seed = new Seed();
		$query = "select * from seed_bank where (children = 0 || children > 1 || (generation % 2 != 0)) and views < 10 order by views asc";
		if( $result = mysql_query( $query ) )
		{
			$numRows = mysql_num_rows( $result );
			if( $numRows > 1 )
			{
				$randomSeed = mt_rand( 0, floor($numRows / 2) - 1 );
				if( mysql_data_seek( $result, $randomSeed ) )
				{
					$row = mysql_fetch_assoc($result);
					$seed->parseRow( $row );
				}
			}
		}
		
		$query = "update seed_bank set views = (views + 1) where id = $seed->id";
		mysql_query( $query );
		
		return $seed;
	}	
}
?>
