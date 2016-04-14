require 'sqlite3'

$db = SQLite3::Database.new "address_book.db"

module AddressDB
	def self.contacts_setup
		$db.execute(
			<<-SQL
				CREATE TABLE contacts (
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				first_name VARCHAR(64) NOT NULL,
				last_name VARCHAR(64) NOT NULL,
				company VARCHAR(64) NOT NULL,
				email_address VARCHAR(64) NOT NULL,
				phone_number VARCHAR(64) NOT NULL
				);
			SQL
		)
	end

	def self.groups_setup
		$db.execute(
			<<-SQL
				CREATE TABLE groups (
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				name VARCHAR(64) NOT NULL
				);
			SQL
		)
	end

	def self.address_book_setup
		$db.execute(
			<<-SQL			
				CREATE TABLE address_book (
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				contact_id INTEGER,
				group_id INTEGER,
				FOREIGN KEY(contact_id) REFERENCES contacts(id),
				FOREIGN KEY(group_id) REFERENCES groups(id)
				);
			SQL
		)
	end

	def self.seed_contacts
		$db.execute(
			<<-SQL
				INSERT INTO contacts
				(first_name, last_name, company, email_address, phone_number)
				VALUES
				('Tony','Stark', 'Stark Industry', 'tstark@awesome.com', '0119-750-3732'),
				('Padme', 'Amadala', 'Naboo', 'padme@queen.com', '0192-123-4215'),
				('Leo', 'Di Caprio', 'Brain', 'leanardo@inception.com', '0000-000-0000');
			SQL
		)		 
	end
	
	def self.seed_groups
		$db.execute(
			<<-SQL
				INSERT INTO groups
				(name)
				VALUES
				('Real'), ('Character');
			 SQL
		)
	end

	def self.seed_address_book
		$db.execute(
			<<-SQL
			INSERT INTO address_book
			(contact_id, group_id)
			VALUES
			('1', '2'),('2', '2'),('3','1');
			SQL
			)
	end

	def self.all_contacts
		$db.execute(
			<<-SQL
			SELECT * FROM contacts ;
			SQL
			)
	end

	def self.all_groups
		$db.execute(
			<<-SQL
			SELECT * FROM groups ;
			SQL
			)
	end

	def self.all_address_book
		$db.execute(
			<<-SQL
			SELECT * FROM address_book
			SQL
			)
	end

	
end

class Contact
	attr_accessor :first_name, :last_name, :company, :email_address, :phone_number

	def initialize(data={})
	@first_name = data[:first_name]
	@last_name = date[:last_name]
	@company = data[:company]
	@email_address = data[:email_address]
	@phone_number =data[:phone_number]
	end

	def self.add(first_name, last_name, company, email_address, phone_number)
		$db.execute(
			"
			INSERT INTO contacts
			(first_name, last_name, company, email_address, phone_number)
			VALUES
			(?, ?, ?, ?, ?) ;
			",[first_name, last_name, company, email_address, phone_number]
		)
	end

	def self.delete(input)
		$db.execute(
			"
			DELETE FROM contacts WHERE id = ?;
			",[input]
			)
	end

	def self.update(first_name, last_name, company, email_address, phone_number, id)
		$db.execute(
			"
			UPDATE contacts 
			SET first_name = ?, last_name = ?, company = ?, email_address = ?, phone_number = ?
			WHERE id = ? ;
			",[first_name, last_name, company, email_address, phone_number, id]
			)
	end


	def self.display_by_groupname(display, condition)
		$db.execute(
			"
			SELECT #{display}
			FROM contacts JOIN address_book ON contacts.id=contact_id
			JOIN groups ON group_id=groups.id
			WHERE name = ?;
			",[condition]
			)
	end

end

class Group
	attr_accessor :name
	
	def initialize(data={})
	@name = data[:name]
	end

	def self.add(name)
		
		$db.execute(
			"
			INSERT INTO groups (name) VALUES (?);
			",[name]
		)
	end

	def self.delete(input)
		$db.execute(
			"
			DELETE FROM groups WHERE id = ? ;
			",[input]
			)
	end


end



