global class ActPaymentDateSetter implements Schedulable {
	List<Invoice_Header__c> invoicesToUpdate = new List<Invoice_Header__c>();
	
	global void execute(SchedulableContext sc) {
		invoicesToUpdate = [SELECT Actual_Payment_Date__c FROM Invoice_Header__c WHERE
							Estimated_Payment_Date__c = TODAY AND Actual_Payment_Date__c = null];

		for(Invoice_Header__c invoice : invoicesToUpdate){
			invoice.Actual_Payment_Date__c = date.today();
		}
		update invoicesToUpdate;
//test
	}
}
