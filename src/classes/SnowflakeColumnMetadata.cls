public with sharing class SnowflakeColumnMetadata {
    
    public String tableName{get;set;} 
    public String columnName{get;set;} 
    public String dataType{get;set;} 
    public Integer characterMaxLength{get;set;} 
    public Integer numericPrecision{get;set;} 
    public Integer numericScale{get;set;} 
    public Integer dateTimePrecision{get;set;} 
    
    public static SnowflakeColumnMetadata fromInformationSchemaQuery(List<String> row){
        SnowflakeColumnMetadata newObject=new SnowflakeColumnMetadata();
        newObject.tableName = row.get(2);
        newObject.columnName = row.get(3);
        newObject.dataType = row.get(4);
        newObject.characterMaxLength = Integer.valueOf(row.get(6));
        newObject.numericPrecision = Integer.valueOf(row.get(7));
        newObject.numericScale = Integer.valueOf(row.get(8));
        newObject.dateTimePrecision = Integer.valueOf(row.get(9));
        return newObject;
    }
}