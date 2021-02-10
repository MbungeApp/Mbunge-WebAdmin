/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package dao

import (
	"context"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"mbunge-admin/models/db"
	"time"
)

/*
roles
none, admin, mps
*/
type ManagementDaoInterface interface {
	//Roles
	ReadRoles() []db.Role
	InsertRole(role db.Role) error
	DeleteRole(roleId string) error

	// Users
	ReadManagers() []db.Management
	InsertManagers(user db.Management) error
	UpdateRole(userId string, roleId string) error
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

// Roles
func (m NewManagementDaoInterface) ReadRoles() []db.Role {
	var roles []db.Role
	cursor, err := rolesCollection(m.Client).Find(context.Background(), bson.M{})
	if err != nil {
		return nil
	}
	err = cursor.All(context.Background(), &roles)
	if err != nil {
		return nil
	}
	return roles
}
func (m NewManagementDaoInterface) InsertRole(role db.Role) error {
	role.CreatedAt = time.Now()
	role.UpdatedAt = time.Now()
	_, err := rolesCollection(m.Client).InsertOne(context.Background(), role)

	if err != nil {
		return err
	}
	return nil
}
func (m NewManagementDaoInterface) DeleteRole(roleId string) error {
	objectID, _ := primitive.ObjectIDFromHex(roleId)
	_, err := rolesCollection(m.Client).DeleteOne(context.Background(), bson.M{
		"_id": objectID,
	})
	if err != nil {
		return err
	}
	return nil
}

// Managers
func (m NewManagementDaoInterface) ReadManagers() []db.Management {
	var managers []db.Management

	cursor, err := managersCollection(m.Client).Find(context.Background(), bson.M{})
	if err != nil {
		return nil
	}
	err = cursor.All(context.Background(), &managers)
	if err != nil {
		return nil
	}
	return managers
}
func (m NewManagementDaoInterface) InsertManagers(user db.Management) error {
	user.CreatedAt = time.Now()
	user.UpdatedAt = time.Now()
	user.Password = "admin1234"
	_, err := managersCollection(m.Client).InsertOne(context.Background(), user)
	if err != nil {
		return err
	}
	return nil
}
func (m NewManagementDaoInterface) UpdateRole(userId string, roleId string) error {
	objID, _ := primitive.ObjectIDFromHex(userId)
	filter := bson.D{{"_id", objID}}
	update := bson.D{{Key: "$set", Value: bson.M{"role": roleId, "updated_at": time.Now()}}}

	_, err := managersCollection(m.Client).UpdateOne(
		context.Background(),
		filter,
		update,
	)
	if err != nil {
		return err
	}
	return nil
}
