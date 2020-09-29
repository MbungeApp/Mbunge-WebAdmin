/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package payload

type Metrics struct {
	TotalUsers         int `json:"total_users"`
	TotalParticipation int `json:"total_participation"`
	TotalResponses     int `json:"total_responses"`
	TotalEvents        int `json:"total_events"`
}
