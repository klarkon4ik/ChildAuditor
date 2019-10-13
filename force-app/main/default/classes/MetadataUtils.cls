/**
 *   @description Utils class for working with Apex reflection possibilities.
 *   @author Klara Ivanchenko
 */
public with sharing class MetadataUtils {

    /**
	 *  Returns DescribeSObjectResult of sObject by record Id.
	 *  @author Klara Ivanchenko
	 */
    public static Map<String, ChildData> getSObjectTypeChildrenData(Id recordId) {
        Schema.DescribeSObjectResult sObjDsr = recordId.getSObjectType().getDescribe();
        
        // object name to relation object data list
        Map<String, ChildData> children = new Map<String, ChildData>();
        for (Schema.ChildRelationship cr: sObjDsr.getChildRelationships()) {
            Schema.DescribeSObjectResult dRes = cr.getChildSObject().getDescribe();
            // field is not deprecated
            if (!cr.isDeprecatedAndHidden()
                // user has access to the object 
                    && dRes.isAccessible()
                // can be queried by User
                    && dRes.isQueryable()
                // system relations or system duplicates (ex: Task WhatId / AccountId)
                && cr.getRelationshipName() != null) {

                String objName = dRes.getName();
                if (children.get(objName) == null) {
                    children.put(objName, new ChildData(dRes));
                }
                children.get(objName).relationships.add(String.valueOf(cr.getField()));				
            }
        }
        return children;
    }
}