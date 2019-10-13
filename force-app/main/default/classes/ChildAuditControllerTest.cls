/**
 *   @description Tests for ChildAuditController functionality.
 *   @author Klara Ivanchenko
 */
@isTest
private class ChildAuditControllerTest {

    /**
    *  @description Prepare test data
    */
    @testSetup
    private static void insertData() {
        Account testAcc = new Account(Name = 'Test Acc');
        insert testAcc;
        List<Contact> testContacts = new List<Contact>{
            new Contact(LastName = 'Test Contact1', AccountId = testAcc.Id),
            new Contact(LastName = 'Test Contact2', AccountId = testAcc.Id)
        };
        insert testContacts;
    }

    /**
     *   @author Klara Ivanchenko
     *   @description Covers getting relationships info for children objets
     */
    @isTest
    static void testGetChildrenRelations() {
        Account testAcc = [SELECT Id FROM Account WHERE Name = 'Test Acc'];
        Test.startTest();
        List<ChildData> children = ChildAuditController.getChildrenRelations(testAcc.Id);
        System.assert(!children.isEmpty(), 'Children objects info should be returned.');
        Test.stopTest();
    }

    /**
     *   @author Klara Ivanchenko
     *   @description Covers getting counts of children records
     */
    @isTest
    static void testGetChildCount() {
        Account testAcc = [SELECT Id FROM Account WHERE Name = 'Test Acc'];
        ChildData contactData = new ChildData(Contact.getSObjectType().getDescribe());
        contactData.relationships.add('AccountId');
        Test.startTest();
        List<ChildData> children = ChildAuditController.getChildCount(testAcc.Id, contactData);
        System.assert(children[0].count == 2, 'Info about 2 children records should be returned.');
        Test.stopTest();
    }
}