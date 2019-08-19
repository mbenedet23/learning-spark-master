set hive.resultset.use.unique.column.names=false;
set hive.query.result.fileformat=SequenceFile;


select * from sccm_stg.sccm12cm_v_jnj_combined_environment limit 10;



WITH 
	
	ci_info as 
	(
       select name,sys_id,sys_class_name
       from servicenow_stg.cmdb_ci           
       WHERE sys_class_name in ('cmdb_ci_app_server','cmdb_ci_cluster','cmdb_ci_db_instance','cmdb_ci_mainframe','cmdb_ci_hp_frame_npar','u_cmdb_ci_port_interface',
	                            'cmdb_ci_msd','cmdb_ci_netgear','cmdb_ci_unix_server','cmdb_ci_appl','cmdb_ci_service','cmdb_ci_circuit','cmdb_ci_datacenter',
							    'cmdb_ci_web_site','cmdb_ci_win_server','cmdb_ci_windows_service','cmdb_ci_rack','cmdb_ci_hp_frame_vpar','cmdb_ci_hpframe')
	),	
	chg_info AS 
	(
		SELECT chg.number
			,chg.dv_requested_by
			,chg.dv_u_change_manager
			,chg.sys_created_on
			,chg.sys_updated_on
			,chg.start_date
			,chg.end_date
			,chg.work_start
			,chg.work_end
			,chg.cab_date
			,chg.dv_opened_by
			,chg.short_description
			,chg.description
			,chg.u_technical_impact
			,chg.cmdb_ci
			,chg.opened_by
			,chg.sys_id
			,chg.dv_assignment_group
			,chg.assignment_group
			,chg.dv_assigned_to
			,chg.dv_u_customer_name
			,chg.dv_impact
			,chg.dv_category
			,chg.dv_location
			,chg.`location`
			,chg.priority
			,chg.dv_priority
			,chg.dv_risk
			,chg.dv_scope
			,chg.u_state
			,chg.dv_u_state
			,chg.urgency
			,chg.dv_urgency
			,chg.u_status
			,chg.dv_u_status
			,chg.dv_type
			,chg.dv_u_emergency_type
			,chg.dv_approval
			,chg.dv_u_framework
			,chg.u_freeze_id
			,chg.dv_u_business_impact
			,chg.dv_u_successful_non_production_change
			,chg.dv_u_successful_prod_changes_within_last_12_months
			,chg.dv_u_co_pir_comments
			,chg.justification
			,chg.dv_u_contingency_plan
			,chg.dv_u_cam_status
			,chg.dv_u_incidents_raised_in_last_90_days
			,chg.dv_u_unsuccessful_changes_in_the_last_90_calender_days
			,chg.dv_u_impacted_company
			,chg.dv_u_journal_complete
		FROM servicenow_stg.change_request chg
		where (cast (chg.u_state as int)  < 900) or (chg.sys_updated_on >  date_add(FROM_UNIXTIME(UNIX_TIMESTAMP()),-14))
		
		UNION ALL
		
		SELECT chg.number
			,chg.dv_requested_by
			,chg.dv_u_change_manager
			,chg.sys_created_on
			,chg.sys_updated_on
			,chg.start_date
			,chg.end_date
			,chg.work_start
			,chg.work_end
			,chg.cab_date
			,chg.dv_opened_by
			,chg.short_description
			,chg.description
			,chg.u_technical_impact
			,chg.cmdb_ci
			,chg.opened_by
			,chg.sys_id
			,chg.dv_assignment_group
			,chg.assignment_group
			,chg.dv_assigned_to
			,chg.dv_u_customer_name
			,chg.dv_impact
			,chg.dv_category
			,chg.dv_location
			,chg.`location`
			,chg.priority
			,chg.dv_priority
			,chg.dv_risk
			,chg.dv_scope
			,chg.u_state
			,chg.dv_u_state
			,chg.urgency
			,chg.dv_urgency
			,chg.u_status
			,chg.dv_u_status
			,chg.dv_type
			,chg.dv_u_emergency_type
			,chg.dv_approval
			,chg.dv_u_framework
			,chg.u_freeze_id
			,chg.dv_u_business_impact
			,chg.dv_u_successful_non_production_change
			,chg.dv_u_successful_prod_changes_within_last_12_months
			,chg.dv_u_co_pir_comments
			,chg.justification
			,chg.dv_u_contingency_plan
			,chg.dv_u_cam_status
			,chg.dv_u_incidents_raised_in_last_90_days
			,chg.dv_u_unsuccessful_changes_in_the_last_90_calender_days
			,chg.dv_u_impacted_company
			,chg.dv_u_journal_complete
		FROM servicenow_stg.nrt_change_request chg
		
    )
	
SELECT chg.number
    ,chg.sys_id
    ,ci.name as ci_name
    ,ci.sys_id as ci_sys_id
	,ci.sys_class_name as ci_class
    ,chg.dv_requested_by
	,chg.dv_u_change_manager
	,chg.sys_created_on
	,chg.sys_updated_on
	,chg.start_date
	,chg.end_date
	,chg.work_start
	,chg.work_end
	,chg.cab_date
	,chg.dv_opened_by
	,chg.short_description
	,chg.description
	,chg.u_technical_impact
	,chg.cmdb_ci
	,chg.opened_by
	,chg.sys_id
	,chg.dv_assignment_group
	,chg.assignment_group
	,chg.dv_assigned_to
	,chg.dv_u_customer_name
	,chg.dv_impact
	,chg.dv_category
	,chg.dv_location
	,chg.`location`
	,chg.priority
	,chg.dv_priority
	,chg.dv_risk
	,chg.dv_scope
	,chg.u_state
	,chg.dv_u_state
	,chg.urgency
	,chg.dv_urgency
	,chg.u_status
	,chg.dv_u_status
	,chg.dv_type
	,chg.dv_u_emergency_type
	,chg.dv_approval
	,chg.dv_u_framework
	,chg.u_freeze_id
	,chg.dv_u_business_impact
	,chg.dv_u_successful_non_production_change
	,chg.dv_u_successful_prod_changes_within_last_12_months
	,chg.dv_u_co_pir_comments
	,chg.justification
	,chg.dv_u_contingency_plan
	,chg.dv_u_cam_status
	,chg.dv_u_incidents_raised_in_last_90_days
	,chg.dv_u_unsuccessful_changes_in_the_last_90_calender_days
	,chg.dv_u_impacted_company
	,chg.dv_u_journal_complete
    ,'Direct' AS reference
        
FROM chg_info chg
INNER JOIN ci_info ci ON chg.cmdb_ci = ci.sys_id 
    
UNION ALL
    
SELECT chg.number
    ,chg.sys_id
    ,ci.name as ci_name
    ,ci.sys_id as ci_sys_id
	,ci.sys_class_name as ci_class
    ,chg.dv_requested_by
	,chg.dv_u_change_manager
	,chg.sys_created_on
	,chg.sys_updated_on
	,chg.start_date
	,chg.end_date
	,chg.work_start
	,chg.work_end
	,chg.cab_date
	,chg.dv_opened_by
	,chg.short_description
	,chg.description
	,chg.u_technical_impact
	,chg.cmdb_ci
	,chg.opened_by
	,chg.sys_id
	,chg.dv_assignment_group
	,chg.assignment_group
	,chg.dv_assigned_to
	,chg.dv_u_customer_name
	,chg.dv_impact
	,chg.dv_category
	,chg.dv_location
	,chg.`location`
	,chg.priority
	,chg.dv_priority
	,chg.dv_risk
	,chg.dv_scope
	,chg.u_state
	,chg.dv_u_state
	,chg.urgency
	,chg.dv_urgency
	,chg.u_status
	,chg.dv_u_status
	,chg.dv_type
	,chg.dv_u_emergency_type
	,chg.dv_approval
	,chg.dv_u_framework
	,chg.u_freeze_id
	,chg.dv_u_business_impact
	,chg.dv_u_successful_non_production_change
	,chg.dv_u_successful_prod_changes_within_last_12_months
	,chg.dv_u_co_pir_comments
	,chg.justification
	,chg.dv_u_contingency_plan
	,chg.dv_u_cam_status
	,chg.dv_u_incidents_raised_in_last_90_days
	,chg.dv_u_unsuccessful_changes_in_the_last_90_calender_days
	,chg.dv_u_impacted_company
	,chg.dv_u_journal_complete
    ,'Task' AS reference

FROM chg_info chg
INNER JOIN servicenow_stg.task_ci tskci ON chg.sys_id = tskci.task
INNER JOIN ci_info ci ON tskci.ci_item = ci.sys_id;
    