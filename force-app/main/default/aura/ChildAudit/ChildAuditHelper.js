({
	showSpinner : function(component) {
        $A.util.removeClass(component.find('spinner'), 'slds-hide');
    },
    hideSpinner : function(component) {
        $A.util.addClass(component.find('spinner'), 'slds-hide');
	},
	enqueueAction : function(component, actionName, params) {
		let helper = this;

        let p = new Promise(function(resolve, reject) {
            let action = component.get(actionName);
            if (params) {
                action.setParams(params);
            }

            action.setCallback(helper, function(response) {
                if (component.isValid() && response.getState() === 'SUCCESS') {
                    resolve(response.getReturnValue());
                } else {
					reject(response.getError());
                }
            });
            $A.enqueueAction(action);
        });
        return p;
    },
    handleShowNotice: function(component, toast) {
        component.find('notifLib').showToast({
            'title': toast.title,
            'message': toast.message,
            'variant': 'warning'
        });
    },
	getAllChildrenCountsAsync: function(component, children) {
        var helper = this;

        let promises = [];
        let parentId = component.get('v.recordId');
        children.forEach(child => {
            var childInfo = helper.getChildInfo(component, parentId, child);
            if (childInfo) {
                promises.push(childInfo);
            }
        }); 

        return Promise.all(promises);
    },
    getChildInfo: function(component, parentId, child) {
        var helper = this;
        return helper.enqueueAction(component, 'c.getChildCount', {
            'parentId' : parentId,
            'child' : child
        }).then($A.getCallback(function(childInfo) {
            return Promise.resolve(childInfo[0]);
        })).catch($A.getCallback(function(error) {
            helper.logErrors(error);
            child.message = 'data is not available';
            return Promise.resolve(child);
        }));
    },
    logErrors: function(errors) {
        if (errors) {
            if (errors[0] && errors[0].message) {
                console.error("Error message: " +  errors[0].message);
            }
        } else {
            console.error("Unknown error");
        }
    }
})