package templates

const (
	OpenshiftDocURL              = "openshift.io/documentation-url"
	OpenshiftProviderDisplayName = "openshift.io/provider-display-name"
	OpenshiftSupportURL          = "openshift.io/support-url"

	KubevirtDefaultOSVariant = "template.kubevirt.io/default-os-variant"

	TemplateKubevirtProvider             = "template.kubevirt.io/provider"
	TemplateKubevirtProviderSupportLevel = "template.kubevirt.io/provider-support-level"
	TemplateKubevirtProviderURL          = "template.kubevirt.io/provider-url"

	OperatorSDKPrimaryResource     = "operator-sdk/primary-resource"
	OperatorSDKPrimaryResourceType = "operator-sdk/primary-resource-type"

	AppKubernetesComponent = "app.kubernetes.io/component"
	AppKubernetesManagedBy = "app.kubernetes.io/managed-by"
	AppKubernetesName      = "app.kubernetes.io/name"
	AppKubernetesPartOf    = "app.kubernetes.io/part-of"
	AppKubernetesVersion   = "app.kubernetes.io/version"

	TemplateVersionLabel         = "template.kubevirt.io/version"
	TemplateTypeLabel            = "template.kubevirt.io/type"
	TemplateOsLabelPrefix        = "os.template.kubevirt.io/"
	TemplateFlavorLabelPrefix    = "flavor.template.kubevirt.io/"
	TemplateWorkloadLabelPrefix  = "workload.template.kubevirt.io/"
	TemplateDeprecatedAnnotation = "template.kubevirt.io/deprecated"

	templateTypeBaseValue = "base"
)
