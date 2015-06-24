# For Task 570 - We're first moving the imprint over to the Project and using the imprint_id over a character string field
# then we're going to update any existing projects without an imprint to Booktrope Editions
class MigrateImprintsToProject < ActiveRecord::Migration
  def up
    # Copy from ControlNumber to Project
    ControlNumber.where('imprint IS NOT NULL').each do |cn|
      imprint = Imprint.find_by_name(cn.imprint)

      if imprint.nil?
        puts "Unable to locate imprint by name #{cn.imprint}"
      else
        cn.project.imprint = imprint
        cn.save
      end
    end

    # Set Booktrope Editions as the default for all projects without an Imprint
    imprint = Imprint.find_by_name('Booktrope Editions')

    Project.where('imprint_id is null').each do |p|
      p.imprint = imprint
      p.save
    end

    # Drop imprint column from ControlNumber
    remove_column :control_numbers, :imprint
  end

  def down
    # Add imprint column to ControlNumber
    add_column :control_numbers, :imprint, :string

    # Copy from Project to ControlNumber
    Project.where('imprint_id IS NOT NULL').each do |p|
      cn = (p.control_number.nil?) ? p.build_control_number : p.control_number
      cn.imprint = p.imprint.name
      cn.save
    end

  end
end
