using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public Transform target;

    public float smoothing = 1f;

    public Vector2 maxPos;

    public Vector2 minPos;
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void LateUpdate()
    {
        if (transform.position != target.position)
        {
            Debug.Log("CAMERA");

            Vector3 newPos = new Vector3(target.position.x, target.position.y, transform.position.z );


            newPos.x = Mathf.Clamp(newPos.x, minPos.x, maxPos.x);
            newPos.y = Mathf.Clamp(newPos.y, minPos.y, maxPos.y);
                
            transform.position = newPos;

        }

        // clamp
    }
}
