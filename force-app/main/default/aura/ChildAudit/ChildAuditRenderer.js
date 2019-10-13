({
	afterRender: function(component, helper) {
		this.superAfterRender();
		let widgetBody = component.find("widgetBody").getElement();
		let widgetBodyHeight = component.get('v.widgetBodyHeight');
		widgetBody.style.height = widgetBodyHeight + "px";
	}
})