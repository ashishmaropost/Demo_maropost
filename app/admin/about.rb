ActiveAdmin.register About do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title,:image, :description
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
# index do
#     selectable_column
#     id_column
#     column :title
#     column :image 
#     column :description
#     column :created_at
#     actions
#   end

#  show do
#     selectable_column
#     id_column
#     row :title
#     row :image 
#     row :description
#     row :created_at
#   end

 
#   form do |f|
#     f.inputs "About us" do
#       f.input :title
#       f.input :image
#       f.input :description
#     end
#     f.actions
#   end
end
