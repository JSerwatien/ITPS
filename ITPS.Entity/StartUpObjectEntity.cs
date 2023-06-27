
namespace ITPS.Entity
{
    public class StartUpObjectEntity
    {
       public List <StatusEntity> Statuses { get; set; }
       public List <UserEntity> Users { get; set; }
       public List <DepartmentEntity> Departments { get; set; } 
        public Exception ErrorObject { get; set; }
    }
}
