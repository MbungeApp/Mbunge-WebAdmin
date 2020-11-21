/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package response

type Metrics struct {
	Card          Card         `json:"card"`
	MpOfTheWeek   MpOfTheWeek  `json:"mp_of_the_week"`
	GenderRation  GenderRation `json:"gender_ration"`
	UsersLocation []string     `json:"users_location"`
}
type Card struct {
	TotalUsers         int `json:"total_users"`
	TotalParticipation int `json:"total_participation"`
	TotalResponses     int `json:"total_responses"`
	TotalEvents        int `json:"total_events"`
}
type MpOfTheWeek struct {
	Picture      string `json:"picture"`
	Name         string `json:"name"`
	Age          int    `json:"age"`
	Constituency string `json:"constituency"`
	County       string `json:"county"`
}
type GenderRation struct {
	Male   int `json:"male"`
	Female int `json:"female"`
}
