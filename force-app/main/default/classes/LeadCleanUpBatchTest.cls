@IsTest
private class LeadCleanUpBatchTest {
    @TestSetup
    static void setup() {
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 20; i++) {
            leads.add(new Lead(LastName = 'Test Lead ' + i, Status = 'Open - Not Contacted', Company = 'Test Company'));
        }
        insert leads;
        List<Lead> ignoreleads = new List<Lead>();
        for (Integer i = 0; i < 10; i++) {
            ignoreleads.add(new Lead(LastName = 'IgnoreTest Lead ' + i, Status = 'Working - Contacted', Company = 'Test Company'));
        }
        insert ignoreleads;
    }

    @IsTest
    static void testLeadCleanUpBatch() {
        Test.startTest();
        LeadCleanUpBatch batch = new LeadCleanUpBatch();
        Database.executeBatch(batch, 200);
        Test.stopTest();

        // Verify that the batch job has processed the leads
        Integer processedLeadsCount = [SELECT COUNT() FROM Lead WHERE Status = 'Closed - Not Converted'];
        System.assertEquals(20, processedLeadsCount, 'All test leads should have been processed and closed.');
        Integer ignoredLeadsCount = [SELECT COUNT() FROM Lead WHERE Status = 'Working - Contacted'];
        System.assertEquals(10, ignoredLeadsCount, 'Leads with status "Working - Contacted" should not have been processed.');

    }
}