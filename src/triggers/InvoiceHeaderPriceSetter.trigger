trigger InvoiceHeaderPriceSetter on Invoice_Line__c (after insert, after update) {
        
        Invoice_Header__c [] recordsToInsert = new List<Invoice_Header__c>();
    	Decimal totalPrice = 0;
    
        for (Invoice_Line__c invoiceLine : Trigger.new){
            
            Invoice_Header__c invoiceHeader = [SELECT Total_Price__c, (SELECT Total_Price__c FROM
                                               Invoice_Lines__r WHERE Total_Price__c > 0) FROM
                                               Invoice_Header__c WHERE Id = :invoiceLine.Invoice__c];
            
            for (Invoice_Line__c headerInvoiceLine : invoiceHeader.Invoice_Lines__r){
                totalPrice += (Decimal) headerInvoiceLine.get('Total_Price__c');
            }
            
            invoiceHeader.Total_Price__c = totalPrice;
            recordsToInsert.add(invoiceHeader);
        	}
    
    	update recordsToInsert;
		}