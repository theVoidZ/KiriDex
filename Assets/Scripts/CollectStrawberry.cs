using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollectStrawberry : MonoBehaviour
{
    private Renderer renderer;
    private bool isDissolving = false;
    private float fade = 1f;

    private AudioManager audioManager;
    private bool initiated = false;
    private void Start()
    {
        renderer = GetComponent<Renderer>();
        audioManager = GetComponent<AudioManager>();
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (!initiated)
        {
            audioManager.PlaySound("collect_strawberry");
            renderer.material.SetFloat("_Fade", 1f );
            initiated = true;
            isDissolving = true;
        }
    }
    

    private void Update()
    {
        if (isDissolving)
        {
            fade -= Time.deltaTime;

            if (fade <= 0f)
            {
                fade = 0f;
                isDissolving = false;
                this.enabled = false;
            }
            
            renderer.material.SetFloat("_Fade", fade );
        }
    }


}
