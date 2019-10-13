({
	onInit : function(component, event, helper) {
		helper.showSpinner(component);
		let recordId = component.get('v.recordId');

		helper.enqueueAction(component, 'c.getChildrenRelations', {
			'recordId' : recordId
		})
		.then($A.getCallback(function(children) {
			return helper.getAllChildrenCountsAsync(component, children)
		}))
		.then($A.getCallback(function(results) {
			component.set("v.childData", results);
			helper.hideSpinner(component);
		}))
		.catch($A.getCallback(function(error) {
			helper.logErrors(error);
			helper.handleShowNotice(component, {title: "Notification", message: "Something went wrong in children records analysis !"});
        }));
	},
	refresh: function(component, event, helper) {
		helper.showSpinner(component);

		let children = component.get('v.childData');
		helper.getAllChildrenCountsAsync(component, children)
		.then($A.getCallback(function(results) {
			component.set('v.childData', results);
			helper.hideSpinner(component);
		}));
	}
})