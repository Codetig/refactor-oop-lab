class Student
  attr_reader :id
  attr_accessor :squad_id, :name, :age, :spirit_animal

  def initialize params, existing=false
    @id = params["id"]
    @squad_id = params["squad_id"]
    @name = params["name"]
    @age = params["age"]
    @spirit_animal = params["spirit_animal"]||params["spirit"]
    @existing = existing
  end

  def existing?
    @existing
  end

  def self.conn= connection
    @conn = connection
  end

  def self.conn
    @conn
  end


  def self.stFind id
    new conn.exec("SELECT * FROM students WHERE id=$1", [id])[0], true
  end

  def self.create params
    new(params).stSave
  end

  def stSave
    if existing?
      Student.conn.exec("UPDATE students SET squad_id=$1, name=$2, age=$3, spirit_animal=$4 WHERE id=$5", [squad_id, name, age, spirit_animal, id])
    else
      Student.conn.exec("INSERT INTO students (squad_id, name, age, spirit_animal) VALUES ($1, $2, $3, $4)", [squad_id.to_i, name, age.to_i, spirit_animal])
    end
  end

  def stDestroy
    Student.conn.exec("DELETE FROM students WHERE id=$1", [id])
  end


end
