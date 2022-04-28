provider "oci" {}

resource "oci_core_vcn" "generated_oci_core_vcn" {
	cidr_block = "10.210.0.0/16"
	compartment_id = "COMPARTMENT_ID"
	display_name = "$VNC_NAME"
	dns_label = "K8sCluster"
}

resource "oci_core_internet_gateway" "generated_oci_core_internet_gateway" {
	compartment_id = "COMPARTMENT_ID"
	display_name = "$IGW_NAME"
	enabled = "true"
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_nat_gateway" "generated_oci_core_nat_gateway" {
	compartment_id = "COMPARTMENT_ID"
	display_name = "$NGW_NAME"
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_containerengine_cluster" "generated_oci_containerengine_cluster" {
	compartment_id = "COMPARTMENT_ID"
	endpoint_config {
		is_public_ip_enabled = "true"
		subnet_id = "${oci_core_subnet.kubernetes_api_endpoint_subnet.id}"
	}
	freeform_tags = {
		"OKEclusterName" = "K8s_Cluster"
	}
	kubernetes_version = "v1.21.5"
	name = "K8s_Cluster"
	options {
		admission_controller_options {
			is_pod_security_policy_enabled = "false"
		}
		persistent_volume_config {
			freeform_tags = {
				"OKEclusterName" = "K8s_Cluster"
			}
		}
		service_lb_config {
			freeform_tags = {
				"OKEclusterName" = "K8s_Cluster"
			}
		}
		service_lb_subnet_ids = ["${oci_core_subnet.service_lb_subnet.id}"]
	}
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_containerengine_node_pool" "create_node_pool_details0" {
	cluster_id = "${oci_containerengine_cluster.generated_oci_containerengine_cluster.id}"
	compartment_id = "COMPARTMENT_ID"
	freeform_tags = {
		"OKEnodePoolName" = "pool1"
	}
	initial_node_labels {
		key = "name"
		value = "K8s_Cluster"
	}
	kubernetes_version = "v1.21.5"
	name = "pool1"
	node_config_details {
		freeform_tags = {
			"OKEnodePoolName" = "pool1"
		}
		placement_configs {
			availability_domain = "TbRi:SA-SAOPAULO-1-AD-1"
			subnet_id = "${oci_core_subnet.node_subnet.id}"
		}
		size = "2"
	}
	node_shape = "VM.Standard.E3.Flex"
	node_shape_config {
		memory_in_gbs = "16"
		ocpus = "2"
	}
	node_source_details {
		image_id = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaap4vqnlbv42uqk3u64e4tgurbf25i26kv5ab5b22vj5i4r6w7ld6a"
		source_type = "IMAGE"
	}
	ssh_public_key = "$PUB-KEY"
}

resource "oci_core_subnet" "service_lb_subnet" {
	cidr_block = "10.210.20.0/23"
	compartment_id = "COMPARTMENT_ID"
	display_name = "$OKE_LB_SUBNET"
	dns_label = "lbsubbcdc30214"
	prohibit_public_ip_on_vnic = "false"
	route_table_id = "${oci_core_default_route_table.generated_oci_core_default_route_table.id}"
	security_list_ids = ["${oci_core_vcn.generated_oci_core_vcn.default_security_list_id}"]
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_subnet" "node_subnet" {
	cidr_block = "10.210.10.0/23"
	compartment_id = "COMPARTMENT_ID"
	display_name = "$OKE_NODE_SUBNET"
	dns_label = "sub620ac249d"
	prohibit_public_ip_on_vnic = "true"
	route_table_id = "${oci_core_route_table.generated_oci_core_route_table.id}"
	security_list_ids = ["${oci_core_security_list.node_sec_list.id}"]
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_subnet" "kubernetes_api_endpoint_subnet" {
	cidr_block = "10.210.0.0/24"
	compartment_id = "COMPARTMENT_ID"
	display_name = "$OKE_ENDPOINT_SUBNET"
	dns_label = "subac815a332"
	prohibit_public_ip_on_vnic = "false"
	route_table_id = "${oci_core_default_route_table.generated_oci_core_default_route_table.id}"
	security_list_ids = ["${oci_core_security_list.kubernetes_api_endpoint_sec_list.id}"]
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_route_table" "generated_oci_core_route_table" {
	compartment_id = "COMPARTMENT_ID"
	display_name = "oke-private-routetable-K8s_Cluster-147a4ad77"
	route_rules {
		description = "traffic to the internet"
		destination = "0.0.0.0/0"
		destination_type = "CIDR_BLOCK"
		network_entity_id = "${oci_core_nat_gateway.generated_oci_core_nat_gateway.id}"
	}
	route_rules {
		description = "traffic to OCI services"
		destination = "all-gru-services-in-oracle-services-network"
		destination_type = "SERVICE_CIDR_BLOCK"
		network_entity_id = "${oci_core_service_gateway.generated_oci_core_service_gateway.id}"
	}
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_default_route_table" "generated_oci_core_default_route_table" {
	display_name = "oke-public-routetable-K8s_Cluster-147a4ad77"
	route_rules {
		description = "traffic to/from internet"
		destination = "0.0.0.0/0"
		destination_type = "CIDR_BLOCK"
		network_entity_id = "${oci_core_internet_gateway.generated_oci_core_internet_gateway.id}"
	}
	manage_default_resource_id = "${oci_core_vcn.generated_oci_core_vcn.default_route_table_id}"
}

resource "oci_core_security_list" "service_lb_sec_list" {
	compartment_id = "COMPARTMENT_ID"
	display_name = "oke-svclbseclist-quick-K8s_Cluster-147a4ad77"
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_security_list" "node_sec_list" {
	compartment_id = "COMPARTMENT_ID"
	display_name = "oke-nodeseclist-quick-K8s_Cluster-147a4ad77"
	egress_security_rules {
		description = "Allow pods on one worker node to communicate with pods on other worker nodes"
		destination = "10.210.0.0/16"
		destination_type = "CIDR_BLOCK"
		protocol = "all"
		stateless = "false"
	}
	egress_security_rules {
		description = "Access to Kubernetes API Endpoint"
		destination = "10.210.0.0/16"
		destination_type = "CIDR_BLOCK"
		protocol = "6"
		stateless = "false"
	}
	egress_security_rules {
		description = "Kubernetes worker to control plane communication"
		destination = "10.210.0.0/16"
		destination_type = "CIDR_BLOCK"
		protocol = "6"
		stateless = "false"
	}
	egress_security_rules {
		description = "Path discovery"
		destination = "10.210.0.0/16"
		destination_type = "CIDR_BLOCK"
		icmp_options {
			code = "4"
			type = "3"
		}
		protocol = "1"
		stateless = "false"
	}
	egress_security_rules {
		description = "Allow nodes to communicate with OKE to ensure correct start-up and continued functioning"
		destination = "all-gru-services-in-oracle-services-network"
		destination_type = "SERVICE_CIDR_BLOCK"
		protocol = "6"
		stateless = "false"
	}
	egress_security_rules {
		description = "ICMP Access from Kubernetes Control Plane"
		destination = "0.0.0.0/0"
		destination_type = "CIDR_BLOCK"
		icmp_options {
			code = "4"
			type = "3"
		}
		protocol = "1"
		stateless = "false"
	}
	egress_security_rules {
		description = "Worker Nodes access to Internet"
		destination = "0.0.0.0/0"
		destination_type = "CIDR_BLOCK"
		protocol = "all"
		stateless = "false"
	}
	ingress_security_rules {
		description = "Allow pods on one worker node to communicate with pods on other worker nodes"
		protocol = "all"
		source = "10.210.0.0/16"
		stateless = "false"
	}
	ingress_security_rules {
		description = "Path discovery"
		icmp_options {
			code = "4"
			type = "3"
		}
		protocol = "1"
		source = "10.210.0.0/16"
		stateless = "false"
	}
	ingress_security_rules {
		description = "TCP access from Kubernetes Control Plane"
		protocol = "6"
		source = "10.210.0.0/16"
		stateless = "false"
	}
	ingress_security_rules {
		description = "Inbound SSH traffic to worker nodes"
		protocol = "6"
		source = "0.0.0.0/0"
		stateless = "false"
	}
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_security_list" "kubernetes_api_endpoint_sec_list" {
	compartment_id = "COMPARTMENT_ID"
	display_name = "oke-k8sApiEndpoint-quick-K8s_Cluster-147a4ad77"
	egress_security_rules {
		description = "Allow Kubernetes Control Plane to communicate with OKE"
		destination = "all-gru-services-in-oracle-services-network"
		destination_type = "SERVICE_CIDR_BLOCK"
		protocol = "6"
		stateless = "false"
	}
	egress_security_rules {
		description = "All traffic to worker nodes"
		destination = "10.210.0.0/16"
		destination_type = "CIDR_BLOCK"
		protocol = "6"
		stateless = "false"
	}
	egress_security_rules {
		description = "Path discovery"
		destination = "10.210.0.0/16"
		destination_type = "CIDR_BLOCK"
		icmp_options {
			code = "4"
			type = "3"
		}
		protocol = "1"
		stateless = "false"
	}
	ingress_security_rules {
		description = "External access to Kubernetes API endpoint"
		protocol = "6"
		source = "0.0.0.0/0"
		stateless = "false"
	}
	ingress_security_rules {
		description = "Kubernetes worker to Kubernetes API endpoint communication"
		protocol = "6"
		source = "10.210.0.0/16"
		stateless = "false"
	}
	ingress_security_rules {
		description = "Kubernetes worker to control plane communication"
		protocol = "6"
		source = "10.210.0.0/16"
		stateless = "false"
	}
	ingress_security_rules {
		description = "Path discovery"
		icmp_options {
			code = "4"
			type = "3"
		}
		protocol = "1"
		source = "10.210.0.0/16"
		stateless = "false"
	}
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_service_gateway" "generated_oci_core_service_gateway" {
	compartment_id = "COMPARTMENT_ID"
	display_name = "oke-sgw-quick-K8s_Cluster-147a4ad77"
	services {
		service_id = "ocid1.service.oc1.sa-saopaulo-1.aaaaaaaacd57uig6rzxm2qfipukbqpje2bhztqszh3aj7zk2jtvf6gvntena"
	}
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}
