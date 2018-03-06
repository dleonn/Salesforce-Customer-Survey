public with sharing class CustomerServiceCTRL {
	public CustomerServiceCTRL() {}

	@RemoteAction
	public static Map<String, Object> getQuestions(){
		Map<String, Object> mapResponse = new Map<String, Object>();

		Map<String, CustomerServiceQuestions__c> mapCustomerServiceQuestions = CustomerServiceQuestions__c.getAll();
		List<QuestionWrapper> listQuestionW = new List<QuestionWrapper>();

		for(String question : mapCustomerServiceQuestions.keySet()) {
			QuestionWrapper questionObj = new QuestionWrapper();

			questionObj.name =  mapCustomerServiceQuestions.get(question).Name;
			questionObj.question = mapCustomerServiceQuestions.get(question).Question__c;

		    listQuestionW.add(questionObj);
		}

		mapResponse.put('questions', listQuestionW);

		return mapResponse;
	}

	@RemoteAction
	public static Map<String, Object> insertSurvey (String idOpp, String idAccount, String listAnswers){
		Map<String, Object> mapResponse = new Map<String, Object>();
		CustomerService__c cs = new CustomerService__c();

		cs.Opportunity__c = idOpp;
		cs.Account__c = idAccount;

		INSERT cs;

		List<CustomerServiceQuestion__c> listCustomerQuestions = (List<CustomerServiceQuestion__c>) JSON.deserialize(listAnswers, List<CustomerServiceQuestion__c>.class);

		for(CustomerServiceQuestion__c csq : listCustomerQuestions){
			csq.CustomerService__c = cs.id;
		}

		INSERT listCustomerQuestions;

		mapResponse.put('listCSQ', listCustomerQuestions);
		mapResponse.put('cs', cs);

		return mapResponse;
	}

	class QuestionWrapper{
		String name;
		String question;
	}
}