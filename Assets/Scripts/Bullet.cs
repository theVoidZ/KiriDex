using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    private Vector3 direction;
    
    public void SetDirection(Vector3 direction)
    {
        this.direction = direction;
    }
    public void Move()
    {
        transform.position += direction;
        Debug.Log("BULLET MOVED " + direction);
    }
}
