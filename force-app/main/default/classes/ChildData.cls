/**
 *   @description wrapper class that contains sobject info.
 *   @author Klara Ivanchenko
 */
public with sharing class ChildData {
    @AuraEnabled
    public String objectName { get; set;}
    @AuraEnabled
    public List<String> relationships { get; set;}

    @AuraEnabled
    public String pluralLabel { get; set;}
    @AuraEnabled
    public Integer count { get; set;}

    public ChildData() {}
    public ChildData(Schema.DescribeSObjectResult objDsr) {
        this.objectName = objDsr.getName();
        this.pluralLabel = objDsr.getLabelPlural();
        this.relationships = new List<String>();
        this.count = 0;
    }
}
