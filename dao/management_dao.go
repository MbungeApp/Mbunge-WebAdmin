/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package dao

import "go.mongodb.org/mongo-driver/mongo"

type ManagementDaoInterface interface {
}

type NewManagementDaoInterface struct {
	Client *mongo.Client
}

func managersCollection(client *mongo.Client) *mongo.Collection {
	return client.Database("mbunge").Collection("management")
}
func rolesCollection(client *mongo.Client) *mongo.Collection {
	return client.Database("mbunge").Collection("role")
}
