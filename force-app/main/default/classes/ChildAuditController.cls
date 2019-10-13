/**
 *   @description Controller class for child audit controller.
 *   @author Klara Ivanchenko
 */
public with sharing class ChildAuditController {

	@AuraEnabled
	public static List<ChildData> getChildrenRelations(Id recordId) {
		List<ChildData> children = new List<ChildData>();
		if (String.isNotEmpty(recordId)) {
			recordId = String.escapeSingleQuotes(recordId);
			Map<String, ChildData> apiNameToChild = MetadataUtils.getSObjectTypeChildrenData(recordId);
			children = apiNameToChild.values();
		}
		return children;
	}

	/**
	 *  Returns Returns child data.
	 *  @author Klara Ivanchenko
	 */
	 @AuraEnabled
	public static List<ChildData> getChildCount(Id parentId, ChildData child) {
		return getChildrenCounts(parentId, new Map<String, ChildData> {child.objectName => child});
	}

	/**
	 *  Returns Returns list of children data.
	 *  @author Klara Ivanchenko
	 */
	private static List<ChildData> getChildrenCounts(Id parentId, Map<String, ChildData> apiNameToChild) {
		Map<String, String> countQueries = generateChildCountQueries(parentId, apiNameToChild);
		Map<String, Integer> childCounts = queryCounts(countQueries);
		for (String objName: childCounts.keySet()) {
			ChildData child = apiNameToChild.get(objName);
			child.count = childCounts.get(objName);
		}
		return apiNameToChild.values();
	}

	/**
	 *  Returns Returns list of queries for counting children.
	 *  @author Klara Ivanchenko
	 */
	private static Map<String, String> generateChildCountQueries(Id parentId, Map<String, ChildData> childByName) {
		Map<String, String> objToQueryStr = new Map<String, String>();
		for (String objName: childByName.keySet()) {
			List<String> relations = childByName.get(objName).relationships;
			String queryStr = 'SELECT COUNT() FROM ' + objName + ' WHERE ';
			queryStr += String.join(generateRelationsConditions(parentId, relations), ' OR ');
			objToQueryStr.put(objName, queryStr);
		}
		return objToQueryStr;
	}

	/**
	 *  Returns Returns list of conditions for the relationship fields.
	 *  @author Klara Ivanchenko
	 */
	private static List<String> generateRelationsConditions(Id parentId, List<String> relationFields) {
		List<String> conditionsList = new List<String>();
		for (String relationField : relationFields) {
			conditionsList.add(relationField + ' = \'' + parentId + '\'');
		}
		return conditionsList;
	}
	
	/**
	 *  Returns Queries children count upto limit is about to be exceeded or all children have been counted.
	 *  @author Klara Ivanchenko
	 */
	private static Map<String, Integer> queryCounts(Map<String, String> queriesMap) {
		Map<String, Integer> objToChildCount = new Map<String, Integer>();
		for (String objName: queriesMap.keySet()) {
			if (Limits.getLimitQueries() - Limits.getQueries() > 0) {
				Integer count = Database.countquery(queriesMap.get(objName));
				objToChildCount.put(objName, count);
			}
		}
		return objToChildCount;
	}
}