/**
 This class can be used for integration testing with Snowflake
 Currently, it is based on the article linked from the README. TODO: Replace with tables from the Snowflake demo databases. 
**/
public with sharing class SnowflakeIntegrationTests_DO_NOT_PACKAGE {
    static String endpoint='https://your_snowflake_instance.ap-southeast-2.snowflakecomputing.com';
    static String Username = 'user';
    static String password = 'pass';
    static String database = 'DEMO_DB';
    static String role = 'SYSADMIN';
    static String schema = 'PUBLIC';
	static String warehouse = 'COMPUTE_WH';
        
    
    public static void testSnowflakeSync() {
        String url = endpoint+'?database='+database+'&schema='+schema+'&role='+role+'&warehouse='+warehouse;
	    SnowflakeConnection connection = new SnowflakeConnection(url,username,password, new WebRequester());
        List<DataSource.Table> tables = connection.sync();
        System.debug(tables);
        /*
        11:34:32:880 USER_DEBUG [17]|DEBUG|(
        Table:[columns=(
        Column:[decimalPlaces=0, description=DisplayUrl, filterable=true, label=DisplayUrl, length=1000, name=DisplayUrl, referenceTargetField=null, referenceTo=null, sortable=true, type=URL_TYPE], 
        Column:[decimalPlaces=0, description=CUSTOMER_ID, filterable=true, label=CUSTOMER_ID, length=39, name=CUSTOMER_ID, referenceTargetField=null, referenceTo=null, sortable=true, type=STRING_SHORT_TYPE], 
        Column:[decimalPlaces=0, description=ExternalId, filterable=true, label=ExternalId, length=255, name=ExternalId, referenceTargetField=null, referenceTo=null, sortable=true, type=STRING_SHORT_TYPE], 
        Column:[decimalPlaces=0, description=LAST_HIT, filterable=true, label=LAST_HIT, length=9, name=LAST_HIT, referenceTargetField=null, referenceTo=null, sortable=true, type=DATETIME_TYPE], 
        Column:[decimalPlaces=0, description=FIRST_HIT, filterable=true, label=FIRST_HIT, length=9, name=FIRST_HIT, referenceTargetField=null, referenceTo=null, sortable=true, type=DATETIME_TYPE], 
        Column:[decimalPlaces=0, description=PAGE_HITS, filterable=true, label=PAGE_HITS, length=39, name=PAGE_HITS, referenceTargetField=null, referenceTo=null, sortable=true, type=STRING_SHORT_TYPE]), 
        description=CUSTOMER_WEB_SESSIONS, 
        labelPlural=CUSTOMER_WEB_SESSIONS, 
        labelSingular=CUSTOMER_WEB_SESSIONS, 
        name=CUSTOMER_WEB_SESSIONS, 
        nameColumn=CUSTOMER_WEB_SESSIONS])
        */
        System.assertEquals(tables.size(), 1,'Incorrect number of tables in metadata response');
        System.assertEquals(tables.get(0).columns.size(), 6,'Incorrect number of columns in first table in metadata response');
        
        System.assertEquals(tables.get(0).columns.get(0).description, 'DisplayUrl','Expected column 1 in first table to have description "DisplayUrl"');
        System.assertEquals(tables.get(0).columns.get(0).type, DataSource.DataType.URL_TYPE,'Expected column 1 in first table to have type "URL_TYPE"');
        
        System.assertEquals(tables.get(0).columns.get(1).description, 'ExternalId','Expected column 2 in first table to have description "ExternalId"');
        System.assertEquals(tables.get(0).columns.get(1).type, DataSource.DataType.STRING_SHORT_TYPE,'Expected column 2 in first table to have type "STRING_SHORT_TYPE"');

        System.assertEquals(tables.get(0).columns.get(2).description, 'CUSTOMER_ID','Expected column 3 in first table to have description "CUSTOMER_ID"');
        System.assertEquals(tables.get(0).columns.get(2).type, DataSource.DataType.STRING_SHORT_TYPE,'Expected column 3 in first table to have type "STRING_SHORT_TYPE"');

        System.assertEquals(tables.get(0).columns.get(3).description, 'PAGE_HITS','Expected column 4 in first table to have description "PAGE_HITS"');
        System.assertEquals(tables.get(0).columns.get(3).type, DataSource.DataType.STRING_SHORT_TYPE,'Expected column 4 in first table to have type "STRING_SHORT_TYPE"');
        
        System.assertEquals(tables.get(0).columns.get(4).description, 'FIRST_HIT','Expected column 5 in first table to have description "FIRST_HIT"');
        System.assertEquals(tables.get(0).columns.get(4).type, DataSource.DataType.DATETIME_TYPE,'Expected column 5 in first table to have type "DATETIME_TYPE"');
        
        System.assertEquals(tables.get(0).columns.get(5).description, 'LAST_HIT','Expected column 6 in first table to have description "LAST_HIT"');
        System.assertEquals(tables.get(0).columns.get(5).type, DataSource.DataType.DATETIME_TYPE,'Expected column 6 in first table to have type "DATETIME_TYPE"');
        
        System.assertEquals(tables.get(0).description, 'CUSTOMER_WEB_SESSIONS','Expected first table to have description "CUSTOMER_WEB_SESSIONS"');
        System.assertEquals(tables.get(0).name, 'CUSTOMER_WEB_SESSIONS','Expected first table to have name "CUSTOMER_WEB_SESSIONS"');
    }
    
    public static void testSnowflakeQuery1() {
        String url = endpoint+'?database='+database+'&schema='+schema+'&role='+role+'&warehouse='+warehouse;
        
	    SnowflakeConnection connection = new SnowflakeConnection(url,username,password, new WebRequester());
        //(DataSource.QueryContext context)
        DataSource.QueryContext queryContext = new DataSource.QueryContext();
		List<DataSource.Table> metadata = new List<DataSource.Table>();
        DataSource.Column col1=new DataSource.Column();
        col1.name='DisplayUrl';
        col1.type=DataSource.DataType.URL_TYPE;
        DataSource.Column col2=new DataSource.Column();
        col2.name='ExternalId';
        col2.type=DataSource.DataType.STRING_SHORT_TYPE;
        DataSource.Column col3=new DataSource.Column();
        col3.name='CUSTOMER_ID';
        col3.type=DataSource.DataType.INDIRECT_LOOKUP_TYPE;
        DataSource.Column col4=new DataSource.Column();
        col4.name='PAGE_HITS';
        col4.type=DataSource.DataType.STRING_SHORT_TYPE;
        DataSource.Column col5=new DataSource.Column();
        col5.name='FIRST_HIT';
        col5.type=DataSource.DataType.DATETIME_TYPE;
        DataSource.Column col6=new DataSource.Column();
        col6.name='LAST_HIT';
        col6.type=DataSource.DataType.DATETIME_TYPE;
        List<DataSource.Column> columns=new List<DataSource.Column>();
        DataSource.Table table1=new DataSource.Table();
        table1.name='CUSTOMER_WEB_SESSIONS';
        table1.nameColumn='ExternalId';
        columns.add(col1);
        columns.add(col2);
        columns.add(col3);
        columns.add(col4);
        columns.add(col5);
        columns.add(col6);
        table1.columns=columns;
        metadata.add(table1);
        queryContext.metadata=metadata;
        queryContext.offset=0;
        DataSource.TableSelection tableSelection=new DataSource.TableSelection();
        List<DataSource.ColumnSelection> columnSelection=new List<DataSource.ColumnSelection>();
		DataSource.ColumnSelection cs1=new DataSource.ColumnSelection();
        cs1.columnName='FIRST_HIT';
		cs1.tableName='CUSTOMER_WEB_SESSIONS';
		DataSource.ColumnSelection cs2=new DataSource.ColumnSelection();
        cs2.columnName='CUSTOMER_ID';
		cs2.tableName='CUSTOMER_WEB_SESSIONS';
		DataSource.ColumnSelection cs3=new DataSource.ColumnSelection();
        cs3.columnName='ExternalId';
		cs3.tableName='CUSTOMER_WEB_SESSIONS';
		DataSource.ColumnSelection cs4=new DataSource.ColumnSelection();
        cs4.columnName='LAST_HIT';
		cs4.tableName='CUSTOMER_WEB_SESSIONS';
		DataSource.ColumnSelection cs5=new DataSource.ColumnSelection();
        cs5.columnName='PAGE_HITS';
		cs5.tableName='CUSTOMER_WEB_SESSIONS';
        columnSelection.add(cs1);
        columnSelection.add(cs2);
        columnSelection.add(cs3);
        columnSelection.add(cs4);
        columnSelection.add(cs5);
        tableSelection.columnsSelected=columnSelection;
        DataSource.Filter filter = new DataSource.Filter();
        List<DataSource.Filter> subFilters = new List<DataSource.Filter>();
        DataSource.Filter subFilter = new DataSource.Filter();
        subFilter.columnName='CUSTOMER_ID';
        subFilter.columnValue=73153;
        subFilter.tableName='CUSTOMER_WEB_SESSIONS';
        subFilter.type=DataSource.FilterType.EQUALS;
        subFilters.add(subFilter);
        filter.subFilters=subFilters;
        filter.type=DataSource.FilterType.OR_;
        List<DataSource.Order> orders=new List<DataSource.Order>();
        
        DataSource.Order order1=new DataSource.Order();
        order1.columnName='ExternalId';
        order1.direction=DataSource.OrderDirection.DESCENDING;
        order1.tableName='CUSTOMER_WEB_SESSIONS';
        
        DataSource.Order order2=new DataSource.Order();
        order2.columnName='FIRST_HIT';
        order2.direction=DataSource.OrderDirection.ASCENDING;
        order2.tableName='CUSTOMER_WEB_SESSIONS';
        
        
        orders.add(order1);
        orders.add(order2);
        tableSelection.filter=filter;
        tableSelection.tableSelected='CUSTOMER_WEB_SESSIONS';
        tableSelection.order=orders;
        queryContext.tableSelection=tableSelection;
        queryContext.maxResults=10;
        queryContext.offset=0;
        
        
        DataSource.TableResult result = connection.query(queryContext);
		System.assertEquals(result.rows.size(), 3,'Incorrect number of rows in response');
        System.assertEquals(result.rows.get(0).get('CUSTOMER_ID'), '73153','Incorrect value for CUSTOMER_ID in row 1');
        System.assertEquals(result.rows.get(0).get('ExternalId'), '016513f379490014311277123bf40307100350690086e','Incorrect value for ExternalID in row 1');
        System.assertEquals(result.rows.get(0).get('FIRST_HIT'), '2018-07-30 13:48:20','Incorrect value for FIRST_HIT in row 1');
        System.assertEquals(result.rows.get(0).get('LAST_HIT'), '2018-07-30 15:08:21','Incorrect value for LAST_HIT in row 1');
        System.assertEquals(result.rows.get(0).get('PAGE_HITS'), '1079','Incorrect value for PAGE_HITS in row 1');
        
        System.assertEquals(result.rows.get(1).get('CUSTOMER_ID'), '73153','Incorrect value for CUSTOMER_ID in row 2');
        System.assertEquals(result.rows.get(1).get('ExternalId'), '0164ed97b89b000766fe1c8bbef901077001706f00fb8','Incorrect value for ExternalID in row 2');
        System.assertEquals(result.rows.get(1).get('FIRST_HIT'), '2018-07-30 13:48:20','Incorrect value for FIRST_HIT in row 2');
        System.assertEquals(result.rows.get(1).get('LAST_HIT'), '2018-07-30 15:08:21','Incorrect value for LAST_HIT in row 2');
        System.assertEquals(result.rows.get(1).get('PAGE_HITS'), '26','Incorrect value for PAGE_HITS in row 2');
        System.assertEquals(result.success, true,'Expected success to be true');
        
        System.assertEquals(result.rows.get(2).get('CUSTOMER_ID'), '73153','Incorrect value for CUSTOMER_ID in row 3');
        System.assertEquals(result.rows.get(2).get('ExternalId'), '0163987edcb93979387edbc9e7897097edee7e7987333','Incorrect value for ExternalID in row 3');
        System.assertEquals(result.rows.get(2).get('FIRST_HIT'), '2018-07-30 13:48:20','Incorrect value for FIRST_HIT in row 3');
        System.assertEquals(result.rows.get(2).get('LAST_HIT'), '2018-07-30 15:08:21','Incorrect value for LAST_HIT in row 3');
        System.assertEquals(result.rows.get(2).get('PAGE_HITS'), '20','Incorrect value for PAGE_HITS in row 3');
        System.assertEquals(result.success, true,'Expected success to be true');
        
        System.assertEquals(result.totalSize, 3,'Incorrect total size value');
    }
    
}