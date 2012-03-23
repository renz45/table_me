# Table Me 0.0.1  

## Adam Rensel's Code

Widget table helper for Rails

![Dark table_me table](http://cl.ly/3d1U2l0G1a0h2O1K1m3g/Screen%20Shot%202012-02-23%20at%209.47.05%20AM.png)

# Usage
## Controller
A table must first be created in your controller using the `table_me` method.

```ruby
table_me(collection, options)
```

The collection can be two things, first an ActiveRecord::Relation, which is the result of some sort of active record query ex: 

```ruby
table_me( User.where(subscribed: true) )
```
Keep in mind that doing `User.all` just returns an array of objects, not the a relation.

In order to do the equivalent  of the `.all` just pass in the ActiveRecord class:

```ruby
table_me( User )
```

Possible options available for this method are:

`name` - Label for the the table
`per_page` - The amount of items per page of the table

## View
In your view you can create the table from the one initialized in the controller, the first parameter of table_for is the name set in table_me. By default the class name is used if a name isn't set.

### Columns

```ruby
table_for :user
```

Now, this will list all columns from the database in your table, which you may not always want to do. You can pass a block of columns to be more specific:

```ruby
table_for :user do |t|
  t.column :id
  t.column :email
  t.column :created_at
end
```

This will give you a user table with the columns id, email, and created_at.

What if you want to customize the output of the column? Each column can also take a block of content:

```ruby
table_for :user do |t|
  t.column :id
  t.column :email do |c|
    "<h1>c.email</h1>"
  end
  t.column :created_at
end
```

There is also a color highlighting helper called `highlight_cell`. So lets say that you want to have a visual que for if a user is an admin:

![highlight colors](http://cl.ly/3U031f1X1N0I45011K0W/Screen%20Shot%202012-02-23%20at%208.27.31%20AM.png)

```ruby
table_for :user do |t|
  t.column :id
  t.column :admin do |c|
    highlight_cell c.admin, green: true
  end
  t.column :created_at
end
```

This will put a green box around true in the column. But what if you want to change that true to the word 'Admin' and lets put a red box around all the non admins and make them say 'peons':

```ruby
table_for :user do |t|
  t.column :id
  t.column :admin do |c|
    highlight_cell c.admin, green: [true, 'Admin'], red: [false, 'peon']
  end
  t.column :created_at
end
```

### Filters
You can add basic filter fields to the table by using the filter method. Right now, only one filter can be applied and the filters are search fields. I would like to eventually add different types for different types of data. I would like to eventually add in the ability for multiple filter types with a single search button, but the basic form is all I need at the moment. Ajax enabled filtering would be freaking great as well.

Filter usage:

```ruby
table_for :user do |t|
  t.filter :email
  t.filter :name
  t.column :id
  t.column :email 
  t.column :name
end
```

![table filter](http://cl.ly/0B1U1c2Z0O2w1o3j3o3C/Screen%20Shot%202012-03-23%20at%201.52.48%20PM.png)

There is also a light theme, which can be switched by adding a class of 'light' to the table_for:

```ruby
table_for :user, class: 'light'
```
This looks a little like this: 

![table me light table](http://cl.ly/3n410Q2l3C452x1V3Y3R/Screen%20Shot%202012-02-23%20at%209.57.37%20AM.png)

## Things to add
* I would like some sort of scope sorting built in.
* More advanced filtering other then just search fields. Multiple filters at one time.
* Ajax filters instead of having to reload the page. The url will still need to be modified so state can be preserved if the url is copy and pasted.